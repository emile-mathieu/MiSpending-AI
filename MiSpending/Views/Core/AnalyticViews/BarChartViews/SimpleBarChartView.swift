//
//  SimpleBarChartView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 25/03/2025.
//

import SwiftUI
import Charts
struct SimpleBarChartView: View {
    let user: User
    
    var mostSpentCategory: String {
        let categoryTotals = user.expenses.reduce(into: [String: Double]()) { result, expense in
            result[expense.category_name, default: 0] += expense.total_amount_paid
        }
        return categoryTotals.max(by: { $0.value < $1.value })?.key ?? "No Expense"
    }
    var sortedExpenses: [Expense] {
        user.expenses.filter { $0.category_name == mostSpentCategory }
            .sorted { $0.date > $1.date }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                Text("Analyze your spending's based on a selected category.")
            Chart {
                ForEach(sortedExpenses, id: \.id) { expense in
                    BarMark(
                        x: .value("Expense", expense.merchant_name),
                        y: .value("Amount", expense.total_amount_paid)
                    )
                    .cornerRadius(3)
                    .foregroundStyle(expense.category_color)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .aspectRatio(7, contentMode: .fit)
            
        }
    }
}

#Preview {
    SimpleBarChartView(user: getMockData())
}
