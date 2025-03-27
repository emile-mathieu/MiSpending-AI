//
//  ContentUnavailableView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 26/03/2025.
//


import SwiftUI
struct CameraNotAvailable: View {
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle.fill")
                .font(.largeTitle)
                .padding()
            Text("Please Enable Your Camera")
                .font(.headline)
        }
        .foregroundColor(.gray)
    }
}
