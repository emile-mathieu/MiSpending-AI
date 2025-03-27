//
//  OcrHelper.swift
//  MiSpending
//
//  Created by Emile Mathieu on 12/10/2024.
//

import Foundation
import VisionKit

struct APIRequest: Codable {
    let ocr_data: [String]
}

struct APIResponse: Codable {
    let merchant_name: String
    let category_name: String
    let total_amount_paid: Double
    let currency: String
    let date: String
}

func ocr(image: UIImage) async throws -> APIResponse {
    let configuration = ImageAnalyzer.Configuration([.text])
    let analysis = ImageAnalyzer()
    do {
        let results = try await analysis.analyze(image, configuration: configuration)
        let text = results.transcript
        let lines = text.split(separator: "\n")
        
        // Convert [Substring] to [String]
        let convertedArray = lines.map(String.init)
        
        let response = try await fetchData(convertedArray)
        return response
    } catch {
        print("Error: \(error)")
        throw error
    }
    
    
    
}
func fetchData(_ ocrText: [String]) async throws -> APIResponse {
    guard let url = URL(string: "http://localhost:3000/api/extract-receipt") else { throw URLError(.badURL)}
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Create the JSON body from a Codable struct.
    let body = APIRequest(ocr_data: ocrText)
    
    do {
        // Encode the data to JSON.
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData
        
        // Make the asynchronous POST request.
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse,
           (200...299).contains(httpResponse.statusCode) {
            return try JSONDecoder().decode(APIResponse.self, from: data)
        } else {
            throw URLError(.badServerResponse)
        }
    } catch {
        print("Request failed with error:", error.localizedDescription)
        throw error
    }
    
}



