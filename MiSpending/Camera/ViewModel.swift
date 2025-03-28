//
//  ViewModel.swift
//  MiSpending
//
//  Created by Emile Mathieu on 26/03/2025.
//


// ViewModel.swift
import Foundation
import CoreImage
import Observation

final class ViewModel: ObservableObject {
    @Published var currentFrame: CGImage?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let cameraManager = CameraManager()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            await MainActor.run {
                self.currentFrame = image
            }
        }
    }
    func stopSession() {
        cameraManager.stopSession()
    }
    func restartSession() {
        Task {
            await cameraManager.initializeCameraIfNeeded()
            await cameraManager.startSession()
        }
    }
}
