//
//  FloatingSheet.swift
//  MiSpending
//
//  Created by Emile Mathieu on 16/10/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func floatingButtomSheet<Content: View>(isPresented: Binding<Bool>, onDismiss: @escaping () -> () = { }, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
                .presentationCornerRadius(0)
                .presentationBackground(.clear)
                .presentationDragIndicator(.hidden)
            
        }
        
    }
        
}

#Preview {
    ContentView()
}
