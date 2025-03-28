//
//  CameraManager.swift
//  MiSpending
//
//  Created by Emile Mathieu on 26/03/2025.
//


// CameraManager.swift
import Foundation
import AVFoundation
import CoreImage

class CameraManager: NSObject {
    
    private let captureSession = AVCaptureSession()
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
    private var sessionQueue = DispatchQueue(label: "video.preview.session")
    private var isConfigured = false
    // Asynchronously check for camera authorization.
    private var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var authorized = status == .authorized
            if status == .notDetermined {
                authorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return authorized
        }
    }
    
    // Closure to yield CGImages for the preview stream.
    private var addToPreviewStream: ((CGImage) -> Void)?
    
    // AsyncStream for camera preview frames.
    lazy var previewStream: AsyncStream<CGImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { cgImage in
                continuation.yield(cgImage)
            }
        }
    }()
    
    override init() {
        super.init()
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func initializeCameraIfNeeded() async {
        guard !isConfigured else { return }
        await configureSession()
        isConfigured = true
    }
    
    private func configureSession() async {
        guard await isAuthorized,
              let camera = systemPreferredCamera,
              let deviceInput = try? AVCaptureDeviceInput(device: camera)
        else { return }
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        
        guard captureSession.canAddInput(deviceInput) else {
            print("Unable to add device input to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.videoOutput = videoOutput
        
        videoOutput.connection(with: .video)?.videoRotationAngle = 90
    }
    
    func startSession() async {
        guard await isAuthorized else { return }
        // If the session is already running, do nothing.
        if captureSession.isRunning { return }
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let cgImage = sampleBuffer.cgImage else { return }
        addToPreviewStream?(cgImage)
    }
}
