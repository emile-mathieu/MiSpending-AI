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
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) var dismiss
    @Query var onboardedUsers: [Onboard]
    @State private var animateGradient: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    private func handleOnboard() -> Void {
        withAnimation(.easeOut){
            onboardedUsers.first?.hasOnBoarded = true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 25){
                Image("MiSpending-Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .frame(width: 120, height: 120)
                    .padding(.top, 30)
                Text("Sign in to your account")
                    .foregroundStyle(.primary)
                    .font(.title)
                    .bold()
                VStack {
                    Button(action: {}) {
                        Label("Sign in with Apple", systemImage: "applelogo")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(scheme == .light ? Color.gray.opacity(0.2) : .white)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                    }
                    Button(action: {}) {
                        Label("Sign in with Google", systemImage: "graduationcap.fill")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(scheme == .light ? Color.gray.opacity(0.2) : .white)
                            .foregroundStyle(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                    }
                    HStack {
                        Divider()
                            .frame(width: 90, height: 1)
                            .background(Color.gray)
                        
                        Text("Or continue with")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(width: 90, height: 1)
                            .background(Color.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(scheme == .light ? .gray : .white, lineWidth:1))
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(scheme == .light ? .gray : .white, lineWidth:1))
                        Button(action: {}){
                            Text("Forgot password?")
                                .font(.subheadline)
                                .foregroundStyle(scheme == .light ? .black : .white)
                                .padding()
                        }
                        Button(action: {}) {
                            Text("Login")
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: 65)
                                .background(scheme == .light ? .black : .white)
                                .foregroundStyle(scheme == .light ? .white : .black)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                }.padding()
                Spacer()
                
                
            }.toolbar{
                ToolbarItem(placement: .automatic){
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(.black)
                            .font(.system(size: 20))
                    }
                }
                
            }
        }
        
    }
}

#Preview {
    LoginView()
    //        .frame(maxWidth: .infinity, maxHeight: .infinity)
    //        .background{
    //            LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
    //                .ignoresSafeArea()
    //                .hueRotation(.degrees(animateGradient ? 45 : 0))
    //                .onAppear{
    //                    withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: true)){
    //                        animateGradient.toggle()
    //                    }
    //                }
    //        }
}
