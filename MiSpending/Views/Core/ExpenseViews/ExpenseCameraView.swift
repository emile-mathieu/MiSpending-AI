//
//  ExpenseCameraView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 06/03/2025.
//

import SwiftUI
import SwiftData
struct ExpenseCameraView: View {
    @Environment(\.dismiss) var dismiss
    @Query var user: [User]
    
    let imageTaken: UIImage
    
    
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryCurrency: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    @FocusState private var isFocused: Bool
    
    //    private func scan() async{
    //            try? await ocr(image: imageTaken)
    //        }
    
    private func saveChanges() {
        let newExpense: Expense = .init(merchant_name: temporaryName, category_name: temporaryCategoryType, total_amount_paid: temporaryAmount, currency: temporaryCurrency, date: temporaryDate)
        user.first!.expenses.append(newExpense)
        dismiss()
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
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
        Section(header: Text("Transaction Name")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
            TextField("Name", text: $temporaryName)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                
            }.padding(.bottom, 5)
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
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 5)
    }
    private var currencyAndAmountSection: some View {
        Section(header: Text("Amount")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
                TextField("Amount", value: $temporaryAmount, format: .currency(code: user.first!.preferredCurrency))
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    .frame(maxWidth: .infinity)
                    .focused($isFocused)
        }.padding(.bottom, 5)
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
            Image(systemName: "chevron.left")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    let testImage = UIImage(named: "receipt-test")
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: User.self, configurations: config)
    container.mainContext.insert(getMockData())
    return ExpenseCameraView(imageTaken: testImage!).modelContainer(container)
}
