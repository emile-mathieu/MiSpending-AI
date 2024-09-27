//
//  Item.swift
//  MiSpending
//
//  Created by Emile Mathieu on 15/09/2024.
//

import Foundation
import SwiftData

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
