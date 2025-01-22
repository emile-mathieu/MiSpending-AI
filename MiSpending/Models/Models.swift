//
//  Item.swift
//  MiSpending
//
//  Created by Emile Mathieu on 15/09/2024.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    @Attribute var id = UUID()
    @Attribute var name: String
    @Attribute var email: String?
    @Attribute var password: String?
    @Attribute var preferredCurrency: String
    @Attribute var preferredColorScheme: String?
    @Attribute var categories: [String] = ["Food & Groceries", "Transport", "Housing & Utilities", "Entertainment", "Health & Fitness"]
    @Relationship var expenses: [Expense] = []
    
    init(id: UUID = UUID(), name: String, email: String? = nil, password: String? = nil, preferredCurrency: String, preferredColorScheme: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.preferredCurrency = preferredCurrency
        self.preferredColorScheme = preferredColorScheme
    }
}

@Model
final class Onboard {
    @Attribute var hasOnBoarded: Bool
    init(hasOnboarded: Bool = false) {
        self.hasOnBoarded = hasOnboarded
    }
    
}

@Model
final class Expense: Identifiable {
    @Attribute var id: UUID = UUID()
    @Attribute var merchant_name: String
    @Attribute var category_name: String
    @Attribute var total_amount_paid: Double
    @Attribute var currency: String
    @Attribute var date: Date

    init(id: UUID = UUID(), merchant_name: String, category_name: String, total_amount_paid: Double, currency: String, date: Date) {
        self.merchant_name = merchant_name
        self.category_name = category_name
        self.total_amount_paid = total_amount_paid
        self.currency = currency
        self.date = date
    }
}
