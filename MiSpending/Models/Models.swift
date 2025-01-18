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
    @Relationship var expenses: [Expense] = [] // Establishes a relationship to expenses

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
    @Attribute var title: String
    @Attribute var amount: Double
    @Attribute var date: Date
    @Attribute var category: String

    init(title: String, amount: Double, date: Date, category: String) {
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
    }
}
