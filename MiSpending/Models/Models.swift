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
    @Attribute var preferredCurrency: String?
    @Attribute var preferredColorScheme: String?
    
    init(id: UUID = UUID(), name: String, email: String? = nil, password: String? = nil, preferredCurrency: String? = nil, preferredColorScheme: String? = nil) { // Corrected typo
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.preferredCurrency = preferredCurrency
        self.preferredColorScheme = preferredColorScheme
    }
}


@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Model
final class Onboard {
    @Attribute var hasOnBoarded: Bool
    init(hasOnboarded: Bool = false) {
        self.hasOnBoarded = hasOnboarded
    }
    
}

struct Expense: Hashable {
    let title: String
    let amount: Double
    let date: Date
    let category: String
}
