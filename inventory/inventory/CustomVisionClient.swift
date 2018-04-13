//
//  CustomVisionClient.swift
//  Inventory
//
//  Created by Colby L Williams on 4/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

struct ImageUrl: Codable {
    let Url: String
    let TagIds: [String]
}

struct ImageUrls: Codable {
    let Images: [Image]
    let TagIds: [String]
    
    struct Image: Codable {
        let Url: String
        let TagIds: [String]
    }
}


struct ImageUrlsResponse: Codable {
    let IsBatchSuccessful: Bool
    let Images: [Image]?
    
    struct Image: Codable {
        
        let SourceUrl: String?
        let Status: String
        let Image: Image?
        
        enum Status: String, Codable {
            case ok = "OK"
            case okDuplicate = "OKDuplicate"
            case errorSource = "ErrorSource"
            case errorImageFormat = "ErrorImageFormat"
            case errorImageSize = "ErrorImageSize"
            case errorStorage = "ErrorStorage"
            case errorLimitExceed = "ErrorLimitExceed"
            case errorTagLimitExceed = "ErrorTagLimitExceed"
            case errorUnknown = "ErrorUnknown"
        }
        
        struct Image: Codable {
            let Id: String
            let Created: String
            let Width: Int
            let Height: Int
            let ImageUrl: String?
            let ThumbnailUri: String?
            let Tags: [Tag]?
            let Predictions: [Prediction]?
            
            struct Tag: Codable {
                let TagId: String
                let Created: String
            }
            struct Prediction: Codable {
                let TagId: String
                let Tag: String?
                let Probability: Double
            }
        }
    }
}

class CustomVisionClient {
    
    let projectId = "" // your project id
    let trainingKey = "" // your training key
    
    var createImagesFromUrls: URL? { return URL(string: "https://southcentralus.api.cognitive.microsoft.com/customvision/v1.2/Training/projects/\(projectId)/images/urls") }
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func train(with imageUrls: ImageUrls) {
        
        guard
            !projectId.isEmpty, !trainingKey.isEmpty
        else { fatalError("Must set projectId and trainingId in CustomVisionClient") }
        
        var request = URLRequest(url: createImagesFromUrls!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(trainingKey, forHTTPHeaderField: "Training-key")
        
        do {
            request.httpBody = try encoder.encode(imageUrls)
        } catch {
            print("::::::::::::::::::::   Error: \(error.localizedDescription)")
        }

        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                print("::::::::::::::::::::   Error: \(error.localizedDescription)")
                
            } else if let data = data {
                
                do {
                    
                    let imageUrlsResponse = try self.decoder.decode(ImageUrlsResponse.self, from: data)

                    print("::::::::::::::::::::   Response: \(imageUrlsResponse)")
                    
                } catch {
                    print("::::::::::::::::::::   Error: \(error.localizedDescription)")
                    print("::::::::::::::::::::   Response: \(String(data: data, encoding: .utf8) ?? "fail")")
                }
            } else {
                print("::::::::::::::::::::   Error: fail")
            }
        }.resume()
    }
}
