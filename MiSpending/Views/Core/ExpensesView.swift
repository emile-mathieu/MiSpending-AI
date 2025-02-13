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
    private func totalExpenses() -> Int {
        let expenses = user.first?.expenses ?? []
        var total: Int = 0
        for expense in expenses {
            total += Int(expense.total_amount_paid)
        }
        return total
    }
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 180)
                                .padding(.horizontal)
                            
                            DisplayAmountView(budget: user.first!.budget, totalExpenses: totalExpenses(), localCurrency: currencySymbol)
                            
                        }.shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                        
                        // Transaction History Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Transaction History")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("01 Jan 2025 - 31 Jan 2025")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        if let user = user.first, !user.expenses.isEmpty {
                            LazyVStack(spacing: 10) {
                                ForEach(user.expenses.sorted { $0.date > $1.date }, id: \.self) { expense in
                                    NavigationLink(destination: ExpenseDetailView(user: user, expense: expense)){
                                        expenseRowView(expense: expense)
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return ExpensesView().modelContainer(container)
}


private struct DisplayAmountView: View {
    let budget: Int
    let totalExpenses: Int
    let localCurrency: String
    
    var progress: Double {
        return Double(totalExpenses) / Double(budget)
    }
    var currencySymbol: String {
        return localCurrency.first!.uppercased()
    }
    var body: some View {
        VStack(spacing: 8) {
            Text("Budget Limit")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("\(localCurrency)\(budget)")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            HStack(spacing: 5) {
                Text("Total Expenses")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            
            Text("\(localCurrency)\(totalExpenses)")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.white)
                .frame(height: 4)
                .cornerRadius(2)
                .padding(.top, 5)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding(.horizontal, 24)
    }
}



private struct expenseRowView: View {
    let expense: Expense
    
    private func getFirstLetter(_ string: String) -> String {
        string.first?.uppercased() ?? ""
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
                    .foregroundColor(Color.black)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.merchant_name)
                    .foregroundStyle(Color.primary)
                    .font(.headline)
                HStack {
                    Text("Category:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text(expense.category_name)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .underline()
                }
            }
            Spacer()
            Text("£ \(Int(expense.total_amount_paid))")
                .font(.headline)
                .foregroundColor(.black)
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 10, height: 10)
                .foregroundStyle(.gray)
                
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
