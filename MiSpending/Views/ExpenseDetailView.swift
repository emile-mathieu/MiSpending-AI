import SwiftUI

struct ExpenseDetailView: View {
    let currencyList: [String] = ["GBP", "USD", "EUR"]
    @Environment(\.dismiss) var dismiss
    @Bindable var expense: Expense
    @State private var temporaryName: String = ""
    @State private var temporaryCurrency: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    private func loadTemporaryValues() {
        temporaryName = expense.merchant_name
        temporaryCurrency = expense.currency
        temporaryAmount = expense.total_amount_paid
        temporaryDate = expense.date
    }
    private func saveChanges() {
        expense.merchant_name = temporaryName
        expense.currency = temporaryCurrency
        expense.total_amount_paid = temporaryAmount
        expense.date = temporaryDate
        dismiss()
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    transactionNameSection
                    currencyAndAmountSection
                    transactionDateSection
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }.onAppear(perform: loadTemporaryValues)
    }

    private var transactionNameSection: some View {
        Section(header: Text("Transaction Name")
            .font(.footnote)
            .foregroundStyle(Color.secondary)) {
            TextField("Name", text: $temporaryName)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                .padding(.bottom, 5)
        }
    }

    private var currencyAndAmountSection: some View {
        Section(header: Text("Currency & Amount")
            .font(.footnote)
            .foregroundStyle(Color.secondary)) {
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
            .foregroundStyle(Color.secondary)) {
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
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
        }
    }
}

#Preview {
    // Add a preview with a mock `Expense` object
    ExpenseDetailView(expense: .init(merchant_name: "Sample", category_name: "Food", total_amount_paid: 12.34, currency: "GBP", date: Date()))
}
