//
//  OnboardView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 15/09/2024.
//

import SwiftUI
import SwiftData

struct OnboardView: View {
    @Environment(\.modelContext) private var context
    @Query var onboardedUsers: [Onboard]

    var body: some View {
        TabView {
            OnboardingView(systemImageName: "dollarsign.arrow.circlepath", title: "Welcome to MiSpending!", description: "Your simple and personal budget financing app.", showButton: false)
            OnboardingView(systemImageName: "camera.shutter.button", title: "Scan or Add!", description: "Use your camera to Scan receipts automatically or simply add your spendings manually.", showButton: true, onboardUser: onboardedUsers.first)
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .background(.white)
    }
}

struct OnboardingView: View {
    let systemImageName: String
    let title: String
    let description: String
    let showButton: Bool
    var onboardUser: Onboard?
    
    var body: some View {
        
        VStack(alignment:.center, spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                .foregroundStyle(.mint)
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 25)
                    .multilineTextAlignment(.center)
            }
            if showButton {
                Button("Get Started"){
                    withAnimation {
                        onboardUser?.hasOnBoarded = true
                    }
                }.buttonStyle(.borderedProminent)
                    .tint(.cyan)
            }
        }.padding(.top, 10)
    }
}


#Preview {
    OnboardView().modelContainer(for: Onboard.self, inMemory: true)
}
