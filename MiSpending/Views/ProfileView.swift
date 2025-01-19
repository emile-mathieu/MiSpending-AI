//
//  ProfileView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 17/09/2024.
//

import SwiftUI
import SwiftData
struct ProfileView: View {
    @Query var user: [User]
    @State private var name: String = ""
    @State private var preferredCurrency: String = ""
    let currencies = ["GBP", "USD", "EUR"]
    @Environment(\.modelContext) private var context
    private func updateData() {
        guard let user = user.first else { return }
        
        if user.name != name {
            user.name = name
            print("Updated name")
        }
        
        if user.preferredCurrency != preferredCurrency {
            user.preferredCurrency = preferredCurrency
            print("Updated preferred currency")
        }
    }
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Details")) {
                    if let user = user.first {
                        TextField("Name", text: $name).onAppear{
                            name = user.name
                        }
                        Picker("Currency", selection: $preferredCurrency) {
                            ForEach(currencies, id: \.self) {
                                Text($0)
                            }.onAppear {
                                preferredCurrency = user.preferredCurrency
                                
                            }
                        }
                        
                    }
                    
                }
            }.navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.automatic)
        }.onDisappear {
            updateData()
        }
    }
}

#Preview {
    ProfileView()
}
