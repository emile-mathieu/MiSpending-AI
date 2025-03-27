import SwiftUI

struct ExpenseDetailView: View {
    
    let user: User
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(TabBar.self) private var tabBar
    
    @Bindable var expense: Expense
    
    @State private var buttonVisible = false
    
    @State private var temporaryName: String = ""
    @State private var temporaryCategoryType: String = ""
    @State private var temporaryAmount: Double = 0.0
    @State private var temporaryDate: Date = Date()
    
    @FocusState private var isInputActive: Bool
    
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
            Form {
                transactionNameSection
                categorySection
                currencyAndAmountSection
                transactionDateSection
                deleteButton
            }
            .listSectionSpacing(10)
            
                .navigationTitle("Transaction")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(action: {
                            isInputActive = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .foregroundStyle(.black)
                        }
                    }
                }
        }.onAppear {
            withAnimation(.easeInOut(duration: 0.15)) {
                tabBar.showTabBar = false
            }
            if temporaryName.isEmpty {
                loadTemporaryValues()
            }
        }
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.15)) {
                tabBar.showTabBar = true
            }
        }
    }
    
    private var transactionNameSection: some View {
        Section(header: Text("Transaction")) {
            TextField("Name", text: $temporaryName)
                .keyboardType(.default)
                .submitLabel(.done)
                .focused($isInputActive)
        }
    }
    
    private var categorySection: some View {
        Section(header: Text("Category")) {
            NavigationLink(destination: CategoryPickerView(selectedCategory: $temporaryCategoryType, categories: user.categories)) {
                HStack {
                    Text(temporaryCategoryType.isEmpty ? "Category" : temporaryCategoryType)
                }
            }
        }
    }
    private var currencyAndAmountSection: some View {
        Section(header: Text("Amount")) {
            TextField("Amount", value: $temporaryAmount, format: .currency(code: user.preferredCurrency))
                .keyboardType(.decimalPad)
                .focused($isInputActive)
        }
    }
    
    private var transactionDateSection: some View {
        Section(header: Text("Transaction Date")){
            DatePicker("Start Date", selection: $temporaryDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
        }
    }
    private var deleteButton: some View {
        Section {
            Button(action: {
                context.delete(expense)
                dismiss()
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.headline)
                    Text("Delete")
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .buttonStyle(.plain)
            }.opacity(buttonVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        buttonVisible = true
                    }
                }
        }.listRowInsets(EdgeInsets())
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
                            .foregroundStyle(.blue)
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
    ExpenseDetailView(user: .init(name: "Test User", budget: 1000, preferredCurrency: "GBP"), expense: .init(merchant_name: "Sample", category_name: "Food & Groceries", total_amount_paid: 12.34, currency: "GBP", date: Date())).environment(TabBar())
}
