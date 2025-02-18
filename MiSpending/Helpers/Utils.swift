//
//  MockData.swift
//  MiSpending
//
//  Created by Emile Mathieu on 22/01/2025.
//

import Foundation
import SwiftUI

func getMockData() -> User {
    let user: User = .init(name: "Emile", budget: 1000, preferredCurrency: "GBP")
    let calendar = Calendar.current
    let today = Date()

    let mockExpenses = [
        Expense(merchant_name: "Walmart", category_name: "Food & Groceries",
                total_amount_paid: 85.50, currency: "USD", date: today),
        Expense(merchant_name: "Landlord", category_name: "Housing & Utilities",
                total_amount_paid: 460.00, currency: "USD", date: calendar.date(byAdding: .day, value: -3, to: today)!),
        Expense(merchant_name: "Electric Company", category_name: "Transport",
                total_amount_paid: 150.75, currency: "USD", date: calendar.date(byAdding: .day, value: -7, to: today)!),
        Expense(merchant_name: "Co-op", category_name: "Housing & Utilities",
                total_amount_paid: 100.00, currency: "USD", date: calendar.date(byAdding: .day, value: -10, to: today)!),
        Expense(merchant_name: "Nintendo", category_name: "Entertainment",
                total_amount_paid: 75.00, currency: "USD", date: calendar.date(byAdding: .day, value: -15, to: today)!)
    ]
    
    user.expenses.insert(contentsOf: mockExpenses, at: 0)
    return user
}

func topCategory(from expenses: [Expense]) -> String {
    let grouped = Dictionary(grouping: expenses, by: { $0.category_name })
        .mapValues { $0.reduce(0) { $0 + $1.total_amount_paid } }
    return grouped.max(by: { $0.value < $1.value })?.key ?? "No category found"
}

func categoryPercentage(from expenses: [Expense]) -> Double {
    let grouped = Dictionary(grouping: expenses, by: { $0.category_name })
        .mapValues { $0.reduce(0) { $0 + $1.total_amount_paid } }
    guard let maxCategory = grouped.max(by: { $0.value < $1.value }) else {
        return 0
    }
    let totalSpending = grouped.values.reduce(0, +)
    return (maxCategory.value / totalSpending) * 100
}

func groupedExpensesByCategory(expenses: [Expense]) -> [(category: String, total: Double, color: Color)] {
    // Predefined colors for categories
    let categoryColors: [String: Color] = [
        "Food & Groceries": .green,
        "Transport": .blue,
        "Housing & Utilities": .orange,
        "Entertainment": .red,
        "Health & Fitness": .purple
    ]
    
    // Group expenses by category and sum totals
    let grouped = Dictionary(grouping: expenses, by: { $0.category_name })
        .map { (category, expenses) in
            let total = expenses.reduce(0) { $0 + $1.total_amount_paid }
            return (category: category, total: total, color: categoryColors[category] ?? .gray)
        }
    
    return grouped
}
