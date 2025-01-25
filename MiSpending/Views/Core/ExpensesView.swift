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
                                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 170)
                                .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                            
                            VStack {
                                Text("Total Expenses")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                HStack {
                                    Text("£ \(totalExpenses())")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrowshape.down.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }
                        
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
                                ForEach(user.expenses, id: \.self) { expense in
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


struct expenseRowView: View {
    let expense: Expense
    let colors: [Color] = [
        Color.red.opacity(0.2),
        Color.blue.opacity(0.2),
        Color.green.opacity(0.2),
        Color.orange.opacity(0.2),
        Color.purple.opacity(0.2),
        Color.pink.opacity(0.2)
        ]
        
        // Helper function to get a random color
    private func getRandomColor() -> Color {
        colors.randomElement() ?? Color.black.opacity(0.12)
    }
    
    private func getFirstLetter(_ string: String) -> String {
        string.first?.uppercased() ?? ""
    }
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(getRandomColor())
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                Text(getFirstLetter(expense.merchant_name))
                    .font(.headline)
                    .foregroundColor(Color.black)
            }
            
            // Title and Category
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
            
            Spacer() // Pushes the amount to the far right edge
            
            // Amount at the far right
            Text("£ \(Int(expense.total_amount_paid))")
                .font(.headline)
                .foregroundColor(.black)
            Image(systemName: "chevron.right")
                .foregroundStyle(.black)
                
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
