// CIImage+Extension.swift
import CoreImage

extension CIImage {
    var cgImage: CGImage? {
        let context = CIContext()
        return context.createCGImage(self, from: self.extent)
    }
}
