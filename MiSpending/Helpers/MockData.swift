//
//  MockData.swift
//  MiSpending
//
//  Created by Emile Mathieu on 22/01/2025.
//

import Foundation

func getMockData() -> User {
    let user: User = .init(name: "Emile", preferredCurrency: "GBP")
    let calendar = Calendar.current
    let today = Date()

    let mockExpenses = [
        Expense(merchant_name: "Walmart", category_name: "Food & Groceries",
                total_amount_paid: 45.50, currency: "USD", date: today), // Today's date
        Expense(merchant_name: "Landlord", category_name: "Housing & Utilities",
                total_amount_paid: 1200.00, currency: "USD", date: calendar.date(byAdding: .day, value: -3, to: today)!),
        Expense(merchant_name: "Electric Company", category_name: "Transport",
                total_amount_paid: 150.75, currency: "USD", date: calendar.date(byAdding: .day, value: -7, to: today)!),
        Expense(merchant_name: "Co-op", category_name: "Housing & Utilities",
                total_amount_paid: 100.00, currency: "USD", date: calendar.date(byAdding: .day, value: -10, to: today)!),
        Expense(merchant_name: "Nintendo", category_name: "Entertainment",
                total_amount_paid: 50.00, currency: "USD", date: calendar.date(byAdding: .day, value: -15, to: today)!)
    ]
    
    user.expenses.insert(contentsOf: mockExpenses, at: 0)
    return user
}
