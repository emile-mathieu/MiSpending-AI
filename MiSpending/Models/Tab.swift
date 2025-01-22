//
//  Tab.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import Foundation

enum Tab: String, CaseIterable {
    case expenses = "list.bullet"
    case search = "magnifyingglass"
    case addExpense = "plus.circle"
    case categories = "chart.pie"
    case profile = "person.crop.circle"
    
    var title: String {
        switch self {
        case .expenses: return "Expenses"
        case .search: return "Search"
        case .addExpense: return ""
        case .categories: return "Categories"
        case .profile: return "Profile"
        }
    }
}
