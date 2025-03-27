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
    
    @State private var selectedAngle: Int?
    @State private var selectedSector: String?
    @State private var selectedValue: Int?
    
    var groupedData: [(category: String, total: Double, color: Color)] {
        return groupedExpensesByCategory(expenses: user.expenses)
    }
    private func findSelectedAngle(target: Int) -> (String, Int) {
        var accumulated = 0

        for item in groupedData {
            accumulated += Int(item.total)
            if target <= accumulated {
                return (item.category, Int(item.total))
            }
        }

        return ("", 0)
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
                        .opacity(selectedSector == nil ? 1.0 : (selectedSector == data.category ? 1.0 : 0.5))
                        
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: 350)
                .chartAngleSelection(value: $selectedAngle)
                .onChange(of: selectedAngle) { _, newValue in
                    if let newValue {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            (selectedSector, selectedValue) = findSelectedAngle(target: newValue)
                        }
                    }
                }
                .chartBackground { proxy in
                    VStack {
                        Text(selectedSector ?? "Categories")
                            .font(.headline)
                        Text("Total: \(selectedValue ?? 0)")
                            .font(.subheadline)
                    }.foregroundStyle(.primary)
                }
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
