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
    
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryCurrency: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    @FocusState var isInputActive: Bool
    
    private func saveChanges() {
        let newExpense: Expense = .init(merchant_name: temporaryName, category_name: temporaryCategoryType, total_amount_paid: temporaryAmount, currency: user.first!.preferredCurrency, date: temporaryDate)
        user.first!.expenses.append(newExpense)
        dismiss()
    }
    var body: some View {
        NavigationStack {
            Form {
                transactionNameSection
                categorySection
                currencyAndAmountSection
                transactionDateSection
                
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
        }
    }
    
    private var transactionNameSection: some View {
        Section(header: Text("Transaction")) {
            TextField("Name", text: $temporaryName)
        }
    }
    
    private var categorySection: some View {
        Section(header: Text("Category")) {
            NavigationLink(destination: CategoryPickerView(selectedCategory: $temporaryCategoryType, categories: user.first!.categories)) {
                HStack {
                    Text(temporaryCategoryType.isEmpty ? "Category" : temporaryCategoryType)
                }
            }
        }
    }
    private var currencyAndAmountSection: some View {
        Section(header: Text("Amount")) {
            TextField("Amount", value: $temporaryAmount, format: .currency(code: user.first!.preferredCurrency))
                .keyboardType(.decimalPad)
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: {
                            isInputActive = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .foregroundStyle(.primary)
                        }
                    }
                }
            
        }
    }
    
    private var transactionDateSection: some View {
        Section(header: Text("Transaction Date")){
                DatePicker("Start Date", selection: $temporaryDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
    }
    
    private var saveButton: some View {
        Button(action: {
            saveChanges()
            
        }) {
            Text("Save")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
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
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 12).fill(.red))
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return ExpenseSaveView().modelContainer(container)
}
