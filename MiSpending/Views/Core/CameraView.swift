//
//  CameraView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    private func testOcr() async{
        try? await ocr(image: UIImage.receiptTest2)
    }
        var body: some View {
            NavigationStack {
                VStack(alignment: .center, spacing: 20) {
                    Text("Camera View")
                    Button("Try Ocr"){
                        Task {
                            await testOcr()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }.toolbar{
                    ToolbarItem(placement: .automatic){
                        Button("Close"){
                            dismiss()
                        }
                    }
                }
            }
    }
}

#Preview {
    CameraView()
}
