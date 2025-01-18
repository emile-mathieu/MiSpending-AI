//
//  ExpenseDetailView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 18/01/2025.
//

import SwiftUI

struct ExpenseDetailView: View {
    let currencyList: [String] = ["GBP", "USD", "EUR"]
    @State private var transanction_name: String = "Groceries"
    @State private var currency: String = "GBP"
    @State private var amount: Double = 34.3
    @State private var date = Date()
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                VStack(alignment: .leading, spacing: 10) {
                    Section(header: Text("Transanction Name").font(.footnote).foregroundStyle(Color.secondary)) {
                        TextField("Name", text: $transanction_name)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            .padding(.bottom, 5)
                        Section(header: Text("Currency & Amount").font(.footnote).foregroundStyle(Color.secondary)) {
                            HStack(spacing: 20) {
                                Picker("Currency", selection: $currency) {
                                    ForEach(currencyList, id: \.self) {
                                        Text($0)
                                    }
                                }.pickerStyle(.menu)
                                    .tint(.primary)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 50)
                                    .background(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                TextField("Amount", text: .constant("£\(amount)"))
                                    .keyboardType(.decimalPad)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                    .frame(maxWidth: .infinity)
                            }.padding(.bottom, 5)
                            Section(header: Text("Transaction Date").font(.footnote).foregroundStyle(Color.secondary)) {
                                DatePicker(
                                        "Start Date",
                                        selection: $date,
                                        displayedComponents: [.date]
                                    )
                                    .datePickerStyle(.graphical)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            }
                        }
                        
                    }
                    Spacer()
                }.padding(.horizontal)
            }.navigationTitle("Transaction")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Save action
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
        }
    }
}

#Preview {
    ExpenseDetailView()
}
