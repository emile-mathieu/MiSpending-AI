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
    let columns = [
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible(), alignment: .center),
        GridItem(.flexible(), alignment: .trailing)
    ]
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
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
                                .foregroundStyle(.primary)
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.secondary.opacity(0.15))
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
                                    .foregroundStyle(.gray)
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
                    .aspectRatio(1, contentMode: .fit)
                    LazyVGrid(columns: columns, spacing: 10) {
                        Text("Name")
                            .font(.headline)
                        Text("Date")
                            .font(.headline)
                        Text("Total Paid")
                            .font(.headline)
                        ForEach(sortedExpenses) { expense in
                            Text(expense.merchant_name)
                            Text(expense.date, style: .date)
                            Text(String(format: "%.0f", expense.total_amount_paid))
                        }
                    }
                }.padding()
                    .navigationTitle("Category Based Spendings")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    BarChartView(user: getMockData())
}
