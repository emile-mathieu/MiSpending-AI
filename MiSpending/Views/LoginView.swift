//
//  LoginView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 11/10/2024.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @Query var onboardedUsers: [Onboard]
    
    private func handleOnboard() -> Void {
        withAnimation(.easeOut){
            onboardedUsers.first?.hasOnBoarded = true
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Top Orange Gradient
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                .clipped()
                
                // Bottom White Section with Curved Border
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .fill(Color.white)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                        .overlay(
                            VStack(spacing: 20) {
                                Text("Welcome to MiSpending!")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                Spacer()
                                // Make fake apple login button
                                Button(action: {}) {
                                    Label("Sign in with Apple", systemImage: "applelogo")
                                        .bold()
                                        .frame(width: geometry.size.width * 0.8, height: 45)
                                        .background(Color.black)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    
                                }
                                
                                
                            }
                        )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .edgesIgnoringSafeArea(.all) // Ensures the gradient goes to the edges
        }
    }
}

#Preview {
    LoginView()
}
