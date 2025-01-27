//
//  CategoriesView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 25/01/2025.
//

import SwiftUI
import SwiftData
import Charts

struct SectorMarkView: View {
    let user: User
    
    var groupedData: [(category: String, total: Double, color: Color)] {
        groupedExpensesByCategory(expenses: user.expenses)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Your most spent category was \(topCategory(from: user.expenses)) at \(String(format: "%.f", categoryPercentage(from: user.expenses)))%.")
                    .multilineTextAlignment(.center)
                Chart {
                    ForEach(groupedData, id: \.category) { data in
                        SectorMark(
                            angle: .value("Amount", data.total),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .cornerRadius(8)
                        .foregroundStyle(data.color)
                        
                    }
                    
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 350)
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 150), spacing: 10)],
                    alignment: .leading,
                    spacing: 10
                ) {
                    ForEach(groupedData, id: \.category) { data in
                        HStack(alignment: .center, spacing: 5) {
                            Circle()
                                .fill(data.color)
                                .frame(width: 10, height: 10)
                            Text(data.category)
                                .font(.headline)
                        }
                    }
                }.padding(.horizontal)
                Spacer()
            }
            .padding()
            .navigationTitle("Expense Categories")
            .navigationBarTitleDisplayMode(.inline)
           
        }
    }
}

#Preview {
    SectorMarkView(user: getMockData())
}
