//
//  CameraModel.swift
//  MiSpending
//
//  Created by Emile Mathieu on 19/02/2025.
//


import AVFoundation
import UIKit

/// CameraModel - Handles the camera functionality using AVCaptureSession.
/// This implementation is based on Apple's recommended practices code.
/// Reference: https://developer.apple.com/documentation/avfoundation/capture_setup

class CameraModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var capturedImage: UIImage?
    @Published var showAlert = false
    var alertMessage = ""

    private var photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput!

    func configure() {
        checkCameraAuthorization { authorized in
            guard authorized else {
                self.alertMessage = "Camera access is denied. Please enable it in settings."
                self.showAlert = true
                return
            }

            DispatchQueue.main.async {
                self.setupSession()
                self.session.startRunning()
            }
        }
    }

    private func checkCameraAuthorization(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        default:
            completion(false)
        }
    }

    private func setupSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        // Add video input
        do {
            if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                }
            }
        } catch {
            alertMessage = "Unable to access the back camera."
            showAlert = true
            session.commitConfiguration()
            return
        }

        // Add photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                let supportedDimensions = captureDevice.activeFormat.supportedMaxPhotoDimensions
                if let maxSupported = supportedDimensions.last {  // Use the highest supported resolution
                    photoOutput.maxPhotoDimensions = maxSupported
                }
            }
        } else {
            alertMessage = "Unable to capture photos."
            showAlert = true
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()
    }
    /// Captures a photo using AVCapturePhotoOutput.
    /// Reference: https://developer.apple.com/documentation/avfoundation/avcapturephotooutput
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            let supportedDimensions = captureDevice.activeFormat.supportedMaxPhotoDimensions
            if let maxSupported = supportedDimensions.last { // Get highest supported resolution
                photoSettings.maxPhotoDimensions = maxSupported
            }
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

/// AVCapturePhotoCaptureDelegate Implementation
/// Apple Reference: https://developer.apple.com/documentation/avfoundation/avcapturephotocapturerecord

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            alertMessage = "Failed to capture photo."
            showAlert = true
            return
        }
        capturedImage = image
    }
}
