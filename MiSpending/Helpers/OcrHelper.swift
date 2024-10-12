//
//  OcrHelper.swift
//  MiSpending
//
//  Created by Emile Mathieu on 12/10/2024.
//

import Foundation
import VisionKit

func ocr(image: UIImage) async throws {
    let configuration = ImageAnalyzer.Configuration([.text])
    let analysis = ImageAnalyzer()
    do {
        let results = try await analysis.analyze(image, configuration: configuration)
        let text = results.transcript
        let lines = text.split(separator: "\n")
        print(lines)
    } catch {
        print("Error: \(error)")
    }
    
}

