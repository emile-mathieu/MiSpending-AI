import SwiftUI

struct ExpenseDetailView: View {

    let user: User
    @Environment(\.dismiss) var dismiss
    @Bindable var expense: Expense
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    @FocusState private var isFocused: Bool
    
    private func loadTemporaryValues() {
        temporaryName = expense.merchant_name
        temporaryCategoryType = expense.category_name
        temporaryAmount = expense.total_amount_paid
        temporaryDate = expense.date
    }
    private func saveChanges() {
        expense.merchant_name = temporaryName
        expense.category_name = temporaryCategoryType
        expense.total_amount_paid = temporaryAmount
        expense.date = temporaryDate
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
                }
            }
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }.onAppear {
            if temporaryName.isEmpty {
                loadTemporaryValues()
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
                .padding(.bottom, 5)
                .focused($isFocused)
        }
    }
    
    private var categorySection: some View {
        VStack(alignment: .leading) {
            Text("Category Type")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            NavigationLink(destination: CategoryPickerView(selectedCategory: $temporaryCategoryType, categories: user.categories)) {
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
        Section(header: Text("Amount")
            .font(.footnote)
            .foregroundStyle(.secondary)) {
                TextField("Amount", value: $temporaryAmount, format: .currency(code: user.preferredCurrency))
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
}

struct CategoryPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: String
    let categories: [String]
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    if category == selectedCategory {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        selectedCategory = category
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Add a preview with a mock `Expense` object
    ExpenseDetailView(user: .init(name: "Test User", budget: 1000, preferredCurrency: "GBP"), expense: .init(merchant_name: "Sample", category_name: "Food & Groceries", total_amount_paid: 12.34, currency: "GBP", date: Date()))
}
