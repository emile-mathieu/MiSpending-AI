// CMSampleBuffer+Extension.swift
import AVFoundation
import CoreImage

extension CMSampleBuffer {
    var cgImage: CGImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        return ciImage.cgImage
    }
}

