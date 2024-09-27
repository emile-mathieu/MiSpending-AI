//
//  ContentView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 15/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var onboardedUsers: [Onboard]
    
    private var shouldShowOnboarding: Bool {
        onboardedUsers.isEmpty || onboardedUsers.first?.hasOnBoarded == false
    }
    
    private func saveOnBoardUser() -> Void {
        let newOnboard = Onboard()
        context.insert(newOnboard)
    }
    
    var body: some View {
        Group {
            if shouldShowOnboarding {
                OnboardView()
            } else {
                HomeView()
            }
        }.onAppear {
            if onboardedUsers.isEmpty {
                saveOnBoardUser()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Onboard.self, inMemory: true)
}
