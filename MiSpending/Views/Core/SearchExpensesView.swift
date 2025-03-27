//
//  SearchExpensesView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 27/01/2025.
//

import SwiftUI
import SwiftData
struct SearchExpensesView: View {
    @Query var user: [User]
    @State private var searchText: String = ""
    var searchResults: [Expense] {
        searchText.isEmpty
        ? user.first!.expenses.sorted { $0.date > $1.date }
        : user.first!.expenses
            .filter { $0.merchant_name.lowercased().contains(searchText.lowercased()) }
            .sorted { $0.date > $1.date }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 0) {
                    if let user = user.first, !user.expenses.isEmpty {
                        List {
                            ForEach(searchResults, id: \.self) { expense in
                                NavigationLink(destination: ExpenseDetailView(user: user, expense: expense)){
                                    expenseRowView(expense: expense)
                                    
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .searchable(text: $searchText)
                    } else {
                        Text("No expenses found")
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}

private struct expenseRowView: View {
    @Environment(\.colorScheme) private var scheme
    let expense: Expense
    
    private func getFirstLetter(_ string: String) -> String {
        string.first?.uppercased() ?? ""
    }
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(expense.category_color.opacity(0.2))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .frame(width: 50, height: 50)
                Text(getFirstLetter(expense.merchant_name))
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(expense.merchant_name)
                    .foregroundStyle(.primary)
                    .font(.headline)
                HStack {
                    Text("Category:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(expense.category_name)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .underline()
                }
            }
            Spacer()
            Text("£ \(Int(expense.total_amount_paid))")
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(scheme == .light ? .white : .gray.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return SearchExpensesView().modelContainer(container)
}
