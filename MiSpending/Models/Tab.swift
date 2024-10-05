//
//  Tab.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import Foundation
import SwiftUI

enum Tab: String, CaseIterable {
    case expenses = "list.bullet"
    case addExpense = "plus.circle"
    case profile = "person.crop.circle"
    
    var title: String {
        switch self {
        case .expenses: return "Expenses"
        case .addExpense: return ""
        case .profile: return "Profile"
        }
    }
}
