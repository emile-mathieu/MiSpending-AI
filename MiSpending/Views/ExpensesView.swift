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
    let expenses: [Expense] = [
        .init(title: "Groceries", amount: 500.00, date: Date(), category: "Food"),
        .init(title: "Rent", amount: 1000.00, date: Date(), category: "Bills"),
        .init(title: "Car Insurance", amount: 150.00, date: Date(), category: "Bills"),
        .init(title: "Gas", amount: 100.00, date: Date(), category: "Bills"),
    ]
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Total Expenses Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 2)
                                .frame(height: 170)
                                .padding(.horizontal)
                            
                            VStack {
                                Text("Total Expenses")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Text("£ 180")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
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
                            VStack(spacing: 10) {
                                ForEach(expenses, id: \.self) { expense in
                                    expenseRowView(expense: expense)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }.background(Color.black.opacity(0.05))
            }
            .navigationTitle("Expenses")
        }
    }
}

#Preview {
    let user: User = .init(name: "Emile", preferredCurrency: "GBP")
    let mockExpenses = [
        Expense(title: "Groceries", amount: 45.50, date: Date(), category: "Food"),
        Expense(title: "Rent", amount: 1200.00, date: Date(), category: "Housing"),
        Expense(title: "Utilities", amount: 150.75, date: Date(), category: "Energy"),
        ]
    user.expenses = mockExpenses
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(user)
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
                Text(getFirstLetter(expense.title))
                    .font(.headline)
                    .foregroundColor(Color.black)
            }
            
            // Title and Category
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.title)
                    .font(.headline)
                HStack {
                    Text("Category:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text(expense.category)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .underline()
                }
            }
            
            Spacer() // Pushes the amount to the far right edge
            
            // Amount at the far right
            Text("£ \(Int(expense.amount))")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
