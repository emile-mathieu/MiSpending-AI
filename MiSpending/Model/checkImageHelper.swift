//
//  checkImageHelper.swift
//  MiSpending
//
//  Created by Emile Mathieu on 20/02/2025.
//

import Foundation
import UIKit
import Combine
import CoreML
func checkImageHelper(image: UIImage) async throws -> String {
    let resizeImage = resizeImage(size: CGSize(width: 360, height: 360), image: image)
    let imgConverted = convertToBuffer(resizeImage: resizeImage)

    do {
        let config = MLModelConfiguration()
        let receiptClassifier = try MiSpendingImageClassifier(configuration: config)
        let prediction = try receiptClassifier.prediction(image: imgConverted!)
        return prediction.target
    }
    catch {
        return ""
    }
    
}

func resizeImage(size: CGSize, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: size))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}
func convertToBuffer(resizeImage: UIImage) -> CVPixelBuffer? {
    let attributes = [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
    ] as CFDictionary
    
    var pixelBuffer: CVPixelBuffer?
    
    let status = CVPixelBufferCreate(
        kCFAllocatorDefault, Int(resizeImage.size.width),
        Int(resizeImage.size.height),
        kCVPixelFormatType_32ARGB,
        attributes,
        &pixelBuffer)
    
    guard (status == kCVReturnSuccess) else {
        return nil
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    
    let context = CGContext(
        data: pixelData,
        width: Int(resizeImage.size.width),
        height: Int(resizeImage.size.height),
        bitsPerComponent: 8,
        bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
        space: rgbColorSpace,
        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    
    context?.translateBy(x: 0, y: resizeImage.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    
    UIGraphicsPushContext(context!)
    resizeImage.draw(in: CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height))
    UIGraphicsPopContext()
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    return pixelBuffer
}
