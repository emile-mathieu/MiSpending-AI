//
//  SimpleGradientAreaMarkView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 01/02/2025.
//

import SwiftUI
import Charts

struct SimpleGradientAreaMarkView: View {
    let user: User
    
    let linearGradient = LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.4),Color.accentColor.opacity(0)]),startPoint: .top, endPoint: .bottom)
    
    var aboveSpendingLimit: Bool {
        return user.expenses.reduce(0) { $0 + Int($1.total_amount_paid) } > user.budget
    }
    var cumulativeExpenses: [Expense] {
        var runningTotal = 0.0
        // First, sort the expenses by date (oldest to newest).
        return user.expenses.sorted { $0.date < $1.date }.map { expense in
            runningTotal += expense.total_amount_paid
            // Return a new Expense where total_amount_paid now represents the cumulative total.
            return Expense(merchant_name: expense.merchant_name, category_name: expense.category_name, total_amount_paid: runningTotal, currency: expense.currency, date: expense.date)
        }
    }
    
    var dateRange: ClosedRange<Date>? {
        guard
            let minDate = user.expenses.map({ $0.date }).min(),
            let maxDate = user.expenses.map({ $0.date }).max()
        else {
            return nil
        }
        return minDate...maxDate
    }
    var body: some View {
        VStack(alignment: .leading) {
            if aboveSpendingLimit {
                Text("You are over your budget!")
                    .foregroundStyle(.red)
                    .font(.headline)
            } else {
                Text("You are currently below your budget!")
                    .foregroundStyle(.green)
                    .font(.headline)
                
            }
            Chart {
                ForEach(cumulativeExpenses) { expense in
                    LineMark(
                        x: .value("Date", expense.date),
                        y: .value("Cumulative Total", expense.total_amount_paid)
                    )
                    .interpolationMethod(.cardinal)
                    .symbol(Circle())
                }
                
                RuleMark(
                    y: .value("Budget", user.budget)
                )
                .foregroundStyle(.green)
                
                ForEach(cumulativeExpenses) { expense in
                    AreaMark(
                        x: .value("Date", expense.date),
                        y: .value("Cumulative Total", expense.total_amount_paid)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(linearGradient)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 7)) { value in
                    AxisGridLine()
                    AxisTick()
                    if let _ = value.as(Date.self) {
                        // Use the updated initializer without a trailing closure.
                        AxisValueLabel(format: Date.FormatStyle().month(.abbreviated).day())
                    }
                }
            }
            .chartXScale(domain: dateRange!)
            .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}

#Preview {
    SimpleGradientAreaMarkView(user: getMockData())
}
