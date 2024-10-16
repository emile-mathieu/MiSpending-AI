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
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var preferredCurrency: String = "GBP"
    
    private func saveUserInfo() {
        let user = User(name: name, preferredCurrency: preferredCurrency)
        context.insert(user)
        dismiss()
    }
    let currencies = ["GBP", "USD", "EUR"]
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
            Text("Please give us your name and what currency you're using.")
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 20) {
                       // Account Name
                       Text("Account Name")
                           .font(.headline)
                       TextField("Enter account name", text: $name)
                           .padding()
                           .background(Color(.secondarySystemBackground))
                           .cornerRadius(8)
                           .shadow(radius: 0)

                       // Currency Selector
                       Text("Currency")
                           .font(.headline)
                       Picker("Select Currency", selection: $preferredCurrency) {
                           ForEach(currencies, id: \.self) {
                               Text($0)
                           }
                       }
                       .pickerStyle(.menu)
                       .padding()
                       .background(Color(.secondarySystemBackground))
                       .cornerRadius(8)
                       .shadow(radius: 0)

            }
            GeometryReader { geometry in
            HStack(spacing: 10){
                    Button(action: saveUserInfo) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: geometry.size.width * 0.7)
                            .background(Color.blue, in: .rect(cornerRadius: 10))
                    }
                    Button(action: {dismiss()}) {
                        Text("Cancel")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: geometry.size.width * 0.3)
                            .background(Color.red, in: .rect(cornerRadius: 10))
                    }
                }
            }
            
        }.padding([.horizontal, .bottom], 15)
            .background(Color.white, in: .rect(cornerRadius: 15))
            .padding(.horizontal, 15)
            
        
    }
}

#Preview {
    UserInfoSheetView().modelContainer(for: User.self, inMemory: true)
}
