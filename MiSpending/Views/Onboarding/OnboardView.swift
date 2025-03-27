//
//  OnboardView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 15/09/2024.
//

import SwiftUI
import SwiftData

struct OnboardView: View {
    @Environment(\.colorScheme) private var scheme
    
    @Query var onboardedUsers: [Onboard]
    @Query var User: [User]
    
    @State private var showingSheet = false
    @State private var showingInfoSheet = false
    @State private var moveArrow = false
    
    private func handleOnboard() -> Void {
        if User.first?.hasChanges == true {
            withAnimation {
                onboardedUsers.first?.hasOnBoarded = true
            }
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
                    
                    Button(action: {showingInfoSheet.toggle(); handleOnboard()}) {
                        HStack(alignment: .center) {
                            Image(systemName: "arrow.right")
                                .offset(x: moveArrow ? 2.5 : 0) // Animate only the arrow
                                .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: moveArrow)
                                .onAppear {
                                    moveArrow.toggle() // Start animation
                                }
                            Text("Get Started")
                        }
                        .bold()
                        .frame(maxWidth: .infinity , maxHeight: 50)
                        .background(Color.primary)
                        .foregroundStyle(scheme == .light ? .white : .black)
                        .clipShape(.capsule)
                        .padding(.top, 20)
                    }
                    .floatingButtomSheet(isPresented: $showingInfoSheet, onDismiss: handleOnboard){
                        UserInfoSheetView()
                            .presentationDetents([.height(580)])
                    }
                    
                    
                    Button(action: {showingSheet.toggle()}) {
                        Text("Sign in / Signup")
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity , maxHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(scheme == .dark ? .white : .black, lineWidth:2)
                            )
                    }.padding(.top, 10)
                        .sheet(isPresented: $showingSheet){
                            LoginView()
                        }
                    
                }.padding()
            }.frame(maxWidth: .infinity, maxHeight: 360)
        }
    }
}


#Preview {
    OnboardView().modelContainer(for: [Onboard.self, User.self], inMemory: true)
}
