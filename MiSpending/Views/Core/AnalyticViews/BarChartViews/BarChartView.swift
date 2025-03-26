//
//  BarChartView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 25/03/2025.
//

import SwiftUI
import Charts
struct BarChartView: View {
    let user: User
    @State private var category: String = "Food & Groceries"

    var sortedExpenses: [Expense] {
        user.expenses.filter { $0.category_name == category }
            .sorted { $0.date > $1.date }
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .center, spacing: 50) {
                Menu {
                    ForEach(user.categories, id: \.self) { categoryIn in
                        Button {
                            category = categoryIn
                        } label: {
                            Label(categoryIn, systemImage: "tag")
                        }
                    }
                } label: {
                    HStack {
                        Text(category)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.black.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 8))
                }
                Chart {
                    ForEach(sortedExpenses, id: \.id) { expense in
                        BarMark(
                            x: .value("Expense", expense.merchant_name),
                            y: .value("Amount", expense.total_amount_paid)
                        )
                        .cornerRadius(5, style: .circular)
                        .foregroundStyle(expense.category_color)
                        .annotation(position: .top) {
                            Text(String(format: "%.0f", expense.total_amount_paid))
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .chartLegend(.hidden)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel {
                            if let text = value.as(String.self) {
                                Text(text)
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        
                    }
                }
                .aspectRatio(0.75, contentMode: .fit)
                .padding()
            }.padding()
                .navigationTitle("Category Based Spendings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    BarChartView(user: getMockData())
}
