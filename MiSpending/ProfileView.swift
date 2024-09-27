//
//  ProfileView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 17/09/2024.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            Group {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }.navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    ProfileView()
}
