//
//  UserInfoSheetView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 16/10/2024.
//

import SwiftUI
import SwiftData

struct UserInfoSheetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var preferredCurrency: String = "GBP"
    @State var budget: Int = 0
    
    let currencies: [String] = ["GBP","EUR","USD","SGD","IDR","MYR"]
    
    var buttonIsEnabled: Bool {
        name.isEmpty || budget == 0
    }
    
    private func saveUserInfo() {
        let user = User(name: name, budget: budget, preferredCurrency: preferredCurrency)
        context.insert(user)
        dismiss()
    }
    
    var body: some View {
            VStack(spacing: 10){
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .foregroundStyle(.secondary)
                    .frame(width: 65, height: 65)
                    .padding(.top, 10)
                Text("User info")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Please give us your name, monthly budget and what currency you're using.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        Text("Account Name")
                            .font(.headline)
                        
                        TextField("Enter account name", text: $name)
                            .keyboardType(.alphabet)
                            .submitLabel(.next)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Monthly Budget")
                            .font(.headline)
                        
                        CustomNumberPadTextField(value: $budget, placeholder: "Amount e.g., 500")
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Currency")
                            .font(.headline)
                        Picker("Select Currency", selection: $preferredCurrency) {
                            ForEach(currencies, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .tint(.primary)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                GeometryReader { geometry in
                    HStack(spacing: 10){
                        Button(action: saveUserInfo) {
                            Text("Save")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: geometry.size.width * 0.7)
                                .background(
                                    buttonIsEnabled ? Color.gray :
                                        Color.blue, in: .rect(cornerRadius: 10))
                                .animation(.linear(duration: 0.2), value: buttonIsEnabled)
                        }.disabled(buttonIsEnabled)
                        
                        Button(action: {dismiss()}) {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: geometry.size.width * 0.3)
                                .background(Color.red, in: .rect(cornerRadius: 10))
                        }
                    }
                }.padding(.top, 10)
                
            }
            .padding([.horizontal, .bottom], 15)
            .background(scheme == .light ? .white : Color(red: 20/255, green: 20/255, blue: 20/255), in: .rect(cornerRadius: 15))
            .padding(.horizontal, 15)
        }
}

#Preview {
    UserInfoSheetView().modelContainer(for: User.self, inMemory: true)
}
