//
//  ExpensesView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import SwiftUI

struct ExpensesView: View {
    let expenses: [Expense] = [
        .init(title: "Groceries", amount: 500.00, date: Date(), category: "Food"),
        .init(title: "Rent", amount: 1000.00, date: Date(), category: "Bills"),
        .init(title: "Car Insurance", amount: 150.00, date: Date(), category: "Bills"),
        .init(title: "Gas", amount: 100.00, date: Date(), category: "Bills"),
    ]
    var body: some View {
        List {
            ForEach(expenses, id: \.self) { expense in
                Text(expense.title)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    ExpensesView()
}
