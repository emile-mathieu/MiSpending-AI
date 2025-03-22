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
        CameraPreview(session: cameraModel.session)
    }
}
