//
//  CameraPreviewContainer.swift
//  MiSpending
//
//  Created by Emile Mathieu on 19/02/2025.
//

import SwiftUI
struct CameraPreviewContainer: View {
    @ObservedObject var cameraModel: CameraModel
    
    var body: some View {
        // Use a fixed height or a ratio if you want a specific aspect ratio.
        // For example, .aspectRatio(4/3, contentMode: .fill) or .frame(height: 300).
        CameraPreview(session: cameraModel.session)
    }
}
