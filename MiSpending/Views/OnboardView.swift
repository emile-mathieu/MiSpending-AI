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
    @Environment(\.colorScheme) private var scheme
    @Query var onboardedUsers: [Onboard]
    
    private func handleOnboard() -> Void {
        withAnimation {
            onboardedUsers.first?.hasOnBoarded = true
        }
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
            VStack {
                Image("MiSpending-Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 250, height: 250)
                    .padding()
                Text("MiSpending")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Spacer()
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 10){
                    Text("Get started to manage your finance and spendings now!")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: geometry.size.width / 2)
                    
                    Button(action: handleOnboard) {
                        Label("Get Started", systemImage: "arrow.right")
                            .bold()
                            .frame(maxWidth: .infinity , maxHeight: 50)
                            .background(Color.primary)
                            .foregroundColor(scheme == .light ? .white : .black)
                            .cornerRadius(25)
                            .padding(.top, 20)
                    }
                    NavigationLink(destination: LoginView()) {
                        Text("Sign in / Signup")
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity , maxHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(scheme == .dark ? .white : .black, lineWidth:2)
                            )
                    }.padding(.top, 10)
                }.padding()
            }.frame(maxWidth: .infinity, maxHeight: 360)
        }
    }
}


#Preview {
    OnboardView().modelContainer(for: Onboard.self, inMemory: true)
}
