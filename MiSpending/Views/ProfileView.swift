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
        
        var shouldSave = false // Flag to track if saving is needed
        
        if user.name != name {
            user.name = name
            shouldSave = true
            print("Updated name")
        }
        
        if user.preferredCurrency != preferredCurrency {
            user.preferredCurrency = preferredCurrency
            shouldSave = true
            print("Updated preferred currency")
        }
        
        if shouldSave {
            do {
                try context.save() // Save only once if there are changes
            } catch {
                print("Failed to save changes: \(error.localizedDescription)")
            }
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
