//
//  SimpleSectorMarkView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 27/01/2025.
//

import SwiftUI
import Charts
struct SimpleSectorMarkView: View {
    
    let user: User
    
    var groupedData: [(category: String, total: Double, color: Color)] {
        groupedExpensesByCategory(expenses: user.expenses)
    }
    var majorCategory: String {
        topCategory(from: user.expenses)
    }
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Your most spent category was ") +
                Text(majorCategory).bold() +
                Text(" at \(String(format: "%.f", categoryPercentage(from: user.expenses)))%.")
            }
            Chart {
                ForEach(groupedData, id: \.category) { data in
                    SectorMark(
                        angle: .value("Amount", data.total),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(8)
                    .foregroundStyle(data.color)
                    .opacity(data.category == majorCategory ? 1 : 0.3)
                    
                }
                
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 75)
        }
    }
}

#Preview {
    SimpleSectorMarkView(user: getMockData())
}
