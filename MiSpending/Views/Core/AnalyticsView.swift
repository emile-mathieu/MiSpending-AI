//
//  AnalyticsView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 26/01/2025.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Query var user: [User]
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: SectorMarkView(user: user.first!)) {
                        SimpleSectorMarkView(user: user.first!)
                    }
                } header: { Text("Expense Categories") }
            }.navigationTitle("Cateogories")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return AnalyticsView().modelContainer(container)
}
