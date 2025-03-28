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
    
    @State private var isLoading = true
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryCurrency: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    @Binding var isSheetPresented: Bool
    
    @FocusState private var isInputActive: Bool
    
    private func saveChanges() {
        let newExpense: Expense = .init(merchant_name: temporaryName, category_name: temporaryCategoryType, total_amount_paid: temporaryAmount, currency: temporaryCurrency, date: temporaryDate)
        user.first!.expenses.append(newExpense)
        isSheetPresented = false
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    CancelButton
                }
            }
            .listSectionSpacing(10)
            .redacted(reason: isLoading ? .placeholder : [])
            .task {
                if temporaryName.isEmpty {
                    var readOCr: [String] = []
                    do {
                        readOCr = try await ocr(image: imageTaken)
                    } catch {
                        dismiss()
                    }
                    let responseData = try? await fetchData(readOCr)
                    temporaryName = responseData?.merchant_name ?? ""
                    temporaryCategoryType = responseData?.category_name ?? ""
                    temporaryCurrency = responseData?.currency ?? ""
                    temporaryAmount = responseData?.total_amount_paid ?? 0.0
                    if let dateString = responseData?.date {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        
                        if let date = formatter.date(from: dateString) {
                            temporaryDate = date
                        } else {
                            temporaryDate = Date()
                        }
                    }
                    isLoading = false
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
                Image(systemName: "chevron.left")
                    .foregroundStyle(.primary)
                    .fontWeight(.bold)
            }
        }
}

#Preview {
//        Uncomment to test but it will break because of API call
//        @Previewable @State var showPreview: Bool = false
//        let testImage = UIImage(named: "MiSpending-Logo")
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try! ModelContainer(for: User.self, configurations: config)
//        container.mainContext.insert(getMockData())
//        return ExpenseCameraView(imageTaken: testImage!, isSheetPresented: $showPreview).modelContainer(container).environment(TabBar())
}
