//
//  HomeView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 17/09/2024.
//

import SwiftUI

struct HomeView: View {
    let expenses: [Expense] = [
        .init(title: "Groceries", amount: 500.00, date: Date(), category: "Food"),
        .init(title: "Rent", amount: 1000.00, date: Date(), category: "Bills"),
        .init(title: "Car Insurance", amount: 150.00, date: Date(), category: "Bills"),
        .init(title: "Gas", amount: 100.00, date: Date(), category: "Bills"),
    ]
    var body: some View {
        TabView {
            List {
                ForEach(expenses, id: \.self) { expense in
                    Text(expense.title)
                        .font(.headline)
                }
            }
            .tabItem { VStack {
                Image(systemName: "list.bullet")
                Text("Expenses")
            } }
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("My Profile")
                            .font(.subheadline)
                    }
                }
        }
    }
}

#Preview {
    HomeView()
}
