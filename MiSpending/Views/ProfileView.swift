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
    var body: some View {
        NavigationStack {
            Group {
                Text("Hello \(user.first?.name ?? "Unknown")!")
            }.navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    ProfileView()
}
