//
//  CameraView.swift
//  MiSpending
//
//  Created by Emile Mathieu on 05/10/2024.
//

import SwiftUI

struct CameraView: View {
    
    private func testOcr() async{
        try? await ocr(image: UIImage.receiptTest)
    }
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Camera View")
            Button("Try Ocr"){
                Task {
                    await testOcr()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        
    }
}

#Preview {
    CameraView()
}
