//
//  ExpensesView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import SwiftUI
import SwiftData
struct ExpensesView: View {
    @Query var user: [User]
    
    var gradient: Gradient {
        if totalExpenses <= user.first!.budget {
            return Gradient(colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)])
        } else {
                return Gradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)])
        }
    }
    var currencySymbol: String {
        switch user.first?.preferredCurrency {
        case "GBP":
            return "£"
        case "EUR":
            return "€"
        case "USD":
            return "$"
        case "SGD":
            return "S$"
        case "IDR":
            return "Rp"
        case "MYR":
            return "RM"
        default:
            return "?"
        }
    }
    var dateRange: String {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: Date()),
              let lastDay = calendar.date(byAdding: .day, value: -1, to: monthInterval.end) else {
            return "Unknown Date"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        
        let startDate = formatter.string(from: monthInterval.start)
        let endDate = formatter.string(from: lastDay)
        return "\(startDate) - \(endDate)"
    }
    private var totalExpenses: Int {
        let expenses = user.first?.expenses ?? []
        var total: Int = 0
        for expense in expenses {
            total += Int(expense.total_amount_paid)
        }
        return total
    }
    var getExpensesOfMonth: [Expense] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        return user.first!.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            let expenseYear = Calendar.current.component(.year, from: expense.date)
            return expenseMonth == currentMonth && expenseYear == currentYear
        }.sorted { $0.date < $1.date }
        
    }
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 180)
                                .padding(.horizontal)
                            
                            DisplayAmountView(budget: user.first!.budget, totalExpenses: totalExpenses, localCurrency: currencySymbol)
                            
                        }.shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Transaction History")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(dateRange)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        if let user = user.first, !user.expenses.isEmpty {
                            LazyVStack(spacing: 15) {
                                ForEach(getExpensesOfMonth, id: \.self) { expense in
                                    NavigationLink(destination: ExpenseDetailView(user: user, expense: expense)){
                                        expenseRowView(expense: expense, currencySymbol: currencySymbol)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }.background(Color(.systemGroupedBackground))
            }.navigationTitle("Expenses")
        }
    }
}


private struct DisplayAmountView: View {
    let budget: Int
    let totalExpenses: Int
    let localCurrency: String
    var progress: Double {
        if (totalExpenses <= budget) {
            return Double(totalExpenses) / Double(budget)
        } else {
            return 1.0
        }
    }
    var currencySymbol: String {
        return localCurrency.first!.uppercased()
    }
    var body: some View {
        VStack(spacing: 8) {
            Text("Budget Limit")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text("\(localCurrency)\(budget)")
                .font(.title3.bold())
                .foregroundStyle(.white)
            
            HStack(spacing: 5) {
                Text("Total Expenses")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
            
            Text("\(localCurrency)\(totalExpenses)")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(.white)
                .frame(height: 4)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.top, 5)
                .animation(.easeInOut(duration: 2), value: progress)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding(.horizontal, 24)
    }
}



private struct expenseRowView: View {
    @Environment(\.colorScheme) private var scheme
    let expense: Expense
    let currencySymbol: String
    
    private func getFirstLetter(_ string: String) -> String {
        string.first?.uppercased() ?? ""
    }
    private func getCurrencySymbol(for currencyCode: String) -> String {
        switch currencyCode {
        case "GBP":
            return "£"
        case "EUR":
            return "€"
        case "USD":
            return "$"
        case "SGD":
            return "S$"
        case "IDR":
            return "Rp"
        case "MYR":
            return "RM"
        default:
            return ""
        }
    }
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(expense.category_color.opacity(0.2))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                Text(getFirstLetter(expense.merchant_name))
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.merchant_name)
                    .foregroundStyle(Color.primary)
                    .font(.headline)
                HStack {
                    Text("Category:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(expense.category_name)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .underline()
                }
            }
            Spacer()
            Text(getCurrencySymbol(for: expense.currency) + String(Int(expense.total_amount_paid)))
                .font(.headline)
                .foregroundStyle(.primary)
            Image("chevron-right")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.primary)
                .frame(width: 20, height: 20)
                
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(scheme == .light ? .white : .gray.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return ExpensesView().modelContainer(container)
}
