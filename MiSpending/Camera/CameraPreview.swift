//
//  CameraPreview.swift
//  MiSpending
//
//  Created by Emile Mathieu on 19/02/2025.
//


import SwiftUI
import AVFoundation


/// Camera Preview (Based on AVCaptureVideoPreviewLayer)
/// Apple Reference: https://developer.apple.com/documentation/avfoundation/avcapturevideopreviewlayer
struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    var session: AVCaptureSession

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {}
}
