//
//  ExpenseSaveView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 22/01/2025.
//

import SwiftUI
import SwiftData
struct ExpenseSaveView: View {

    @Environment(\.dismiss) var dismiss
    
    @Query var user: [User]
    
    @Bindable var expense: Expense
    
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryCurrency: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    let currencyList: [String] = ["GBP", "USD", "EUR"]
    
    private func loadTemporaryValues() {
        temporaryName = expense.merchant_name
        temporaryCategoryType = expense.category_name
        temporaryCurrency = expense.currency
        temporaryAmount = expense.total_amount_paid
        temporaryDate = expense.date
    }
    private func saveChanges() {
        let newExpense: Expense = .init(merchant_name: temporaryName, category_name: temporaryCategoryType, total_amount_paid: temporaryAmount, currency: temporaryCurrency, date: temporaryDate)
        user.first!.expenses.append(newExpense)
        dismiss()
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    transactionNameSection
                    categorySection
                    currencyAndAmountSection
                    transactionDateSection
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 40)
            }
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
                ToolbarItem(placement: .topBarLeading){
                    CancelButton
                }
            }
        }.onAppear(perform: loadTemporaryValues)
    }

    private var transactionNameSection: some View {
        Section(header: Text("Transaction Name")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
            TextField("Name", text: $temporaryName)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .padding(.bottom, 5)
            }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading) {
            Text("Category Type")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            NavigationLink(destination: CategoryPickerView(selectedCategory: $temporaryCategoryType, categories: user.first!.categories)) {
                HStack {
                    Text("Category")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(temporaryCategoryType)
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(PlainButtonStyle()) // Ensures clean tap behavior
        }
        .padding(.vertical, 5)
    }

    private var currencyAndAmountSection: some View {
        Section(header: Text("Currency & Amount")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
            HStack(spacing: 20) {
                Picker("Currency", selection: $temporaryCurrency) {
                    ForEach(currencyList, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .tint(.primary)
                .padding(.vertical, 5)
                .padding(.horizontal, 50)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .frame(maxWidth: .infinity)

                TextField("Amount", value: $temporaryAmount, format: .number)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 5)
        }
    }

    private var transactionDateSection: some View {
        Section(header: Text("Transaction Date")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
            DatePicker("Start Date", selection: $temporaryDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
        }
    }

    private var saveButton: some View {
        Button(action: {
            saveChanges()
            
        }) {
            Text("Save")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(.green))
        }
    }
    private var CancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Cancel")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(.red))
        }
    }
}

#Preview {
    // Add a preview with a mock `Expense` object
    ExpenseDetailView(user: .init(name: "Test User", preferredCurrency: "GBP"), expense: .init(merchant_name: "Sample", category_name: "Food & Groceries", total_amount_paid: 12.34, currency: "GBP", date: Date()))
}
