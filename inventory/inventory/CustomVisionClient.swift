//
//  CustomVisionClient.swift
//  Inventory
//
//  Created by Colby L Williams on 4/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

public class CustomVisionClient {
    
    let host = "southcentralus.api.cognitive.microsoft.com"
    let basePath = "/customvision/v1.2/Training"
    let scheme = "https://"
    
    let trainingKey: String

    public static var defaultProjectId: String = ""
    
    static let iso8601Formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.calendar      = Calendar(identifier: .iso8601)
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return formatter
    }()
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Formatter)
        return encoder
    }()

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Formatter)
        return decoder
    }()
    

    let session: URLSession
    
    
    public init(withTrainingKey key: String, urlSessionConfiguration configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        trainingKey = key
        session = URLSession(configuration: configuration)
    }
    

    public func createImages(inProject projectId: String = defaultProjectId, from data: Data, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> ()) {
        
        let request = dataRequest(for: .createImagesFromData(projectId: projectId), withBody: data)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deleteImages(inProject projectId: String = defaultProjectId, withIds imageIds: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = "imageIds=\(imageIds.joined(separator: ","))"
        
        let request = dataRequest(for: .deleteImages(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageFileCreateBatch: ImageFileCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        let request = dataRequest(for: .createImagesFromFiles(projectId: projectId), withBody: imageFileCreateBatch)
        
        return sendRequest(request, completion: completion)
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageIdCreateBatch: ImageIdCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        let request = dataRequest(for: .createImagesFromPredictions(projectId: projectId), withBody: imageIdCreateBatch)
        
        return sendRequest(request, completion: completion)
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageUrlCreateBatch: ImageUrlCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        let request = dataRequest(for: .createImagesFromUrls(projectId: projectId), withBody: imageUrlCreateBatch)
        
        return sendRequest(request, completion: completion)
    }
    
    public func createProject(withDescription description: String? = nil, inDomain domain: String = "General", completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        var query = "domainId=\(domain)"
        
        if let description = description, !description.isEmpty {
            query += "&description=\(description)"
        }
        
        let request = dataRequest(for: .createProject, withBody: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getProjects(completion: @escaping (CustomVisionResponse<[Project]>) -> Void) {
        
        let request = dataRequest(for: .getProjects)
        
        return sendRequest(request, completion: completion)
    }
    
    public func createTag(inProject projectId: String = defaultProjectId, withName name: String, andDescription description: String? = nil, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        var query = "name=\(name)"
        
        if let description = description, !description.isEmpty {
            query += "&description=\(description)"
        }
        
        let request = dataRequest(for: .createTag(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getTags(inProject projectId: String = defaultProjectId, forIteration iteration: String? = nil, completion: @escaping (CustomVisionResponse<TagList>) -> Void) {
        
        let query = iteration == nil || iteration!.isEmpty ? nil : "iterationId=\(iteration!)"
        
        let request = dataRequest(for: CustomVisionApi.getTags(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deleteTags(inProject projectId: String = defaultProjectId, withTagIds tagIds: [String], from images: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = "tatIds=\(tagIds.joined(separator: ","))&imageIds=\(images.joined(separator: ","))"
        
        let request = dataRequest(for: .deleteImageTags(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func postImageTags(inProject projectId: String = defaultProjectId, with imageTagCreateBatch: ImageTagCreateBatch, completion: @escaping (CustomVisionResponse<ImageTagCreateSummary>) -> Void) {
        
        let request = dataRequest(for: .postImageTags(projectId: projectId), withBody: imageTagCreateBatch)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deleteIteration(fromProject projectId: String = defaultProjectId, withId iterationId: String, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let request = dataRequest(for: .deleteIteration(projectId: projectId, iterationId: iterationId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        let request = dataRequest(for: .getIteration(projectId: projectId, iterationId: iterationId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func updateIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, to iteration: Iteration, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        let request = dataRequest(for: .updateIteration(projectId: projectId, iterationId: iterationId), withBody: iteration)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deletePrediction(fromProject projectId: String = defaultProjectId, withIds ids: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = "ids=\(ids.joined(separator: ","))"
        
        let request = dataRequest(for: .deletePrediction(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deleteProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        CustomVisionClient.defaultProjectId = ""

        let request = dataRequest(for: .deleteProject(projectId: projectId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        let request = dataRequest(for: .getProject(projectId: projectId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func updateProject(withId projectId: String = defaultProjectId, to project: Project, completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        let request = dataRequest(for: .updateProject(projectId: projectId), withBody: project)
        
        return sendRequest(request, completion: completion)
    }
    
    public func deleteTag(fromProject projectId: String = defaultProjectId, withId tagId: String, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let request = dataRequest(for: .deleteTag(projectId: projectId, tagId: tagId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getTag(inProject projectId: String = defaultProjectId, withId tagId: String, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        let request = dataRequest(for: .getTag(projectId: projectId, tagId: tagId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func updateTag(inProject projectId: String = defaultProjectId, withId tagId: String, to tag: Tag, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        let request = dataRequest(for: .updateTag(projectId: projectId, tagId: tagId), withBody: tag)
        
        return sendRequest(request, completion: completion)
    }
    
    public func exportIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, forPlatform platform: Export.Platform, completion: @escaping (CustomVisionResponse<Export>) -> Void) {
        
        let query = "platform=\(platform.rawValue)"
        
        let request = dataRequest(for: .exportIteration(projectId: projectId, iterationId: iterationId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getExports(fromIteration iterationId: String, inProject projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<[Export]>) -> Void) {
        
        let request = dataRequest(for: .getExports(projectId: projectId, iterationId: iterationId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getAccountInfo(completion: @escaping (CustomVisionResponse<Account>) -> Void) {
        
        let request = dataRequest(for: .getAccountInfo)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getDomain(withId domainId: String, completion: @escaping (CustomVisionResponse<Domain>) -> Void) {
        
        let request = dataRequest(for: .getDomain(domainId: domainId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getDomains(completion: @escaping (CustomVisionResponse<[Domain]>) -> Void) {
        
        let request = dataRequest(for: .getDomains)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getPerformance(forIteration iterationId: String, inProject projectId: String = defaultProjectId, withThreshold threshold: Float, completion: @escaping (CustomVisionResponse<IterationPerformance>) -> Void) {
        
        let query = "threshold=\(threshold)"
        
        let request = dataRequest(for: .getIterationPerformance(projectId: projectId, iterationId: iterationId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getIterations(inProject projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<[Iteration]>) -> Void) {
        
        let request = dataRequest(for: .getIterations(projectId: projectId))
        
        return sendRequest(request, completion: completion)
    }
    
    public func getTaggedImages(forIteration iterationId: String, inProject projectId: String = defaultProjectId, withTags tags: [String], orderedBy orderBy: OrderBy, take: Int = 50, skip: Int = 0, completion: @escaping (CustomVisionResponse<[Iteration]>) -> Void) {
        
        let query = "iterationId=\(iterationId)&tagIds=\(tags.joined(separator: ","))&orderBy=\(orderBy.rawValue)&take=\(take)&skip=\(skip)"
        
        let request = dataRequest(for: .getTaggedImages(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func getUntaggedImages(forIteration iterationId: String, inProject projectId: String = defaultProjectId, orderedBy orderBy: OrderBy, take: Int = 50, skip: Int = 0, completion: @escaping (CustomVisionResponse<[Image]>) -> Void) {
        
        let query = "iterationId=\(iterationId)&orderBy=\(orderBy.rawValue)&take=\(take)&skip=\(skip)"
        
        let request = dataRequest(for: .getUntaggedImages(projectId: projectId), withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func queryPredictionResults(inProject projectId: String = defaultProjectId, with predictionQueryToken: PredictionQueryToken, completion: @escaping (CustomVisionResponse<PredictionQuery>) -> Void) {
        
        let request = dataRequest(for: .queryPredictionResults(projectId: projectId), withBody: predictionQueryToken)
        
        return sendRequest(request, completion: completion)
    }
    
    public func quickTestImage(forIteration iterationId: String, inProject projectId: String = defaultProjectId, with imageData: Data, completion: @escaping (CustomVisionResponse<ImagePredictionResult>) -> Void) {
        
        let query = "iterationId=\(iterationId)"
        
        let request = dataRequest(for: .quickTestImage(projectId: projectId), withBody: imageData, withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func quickTestImageUrl(forIteration iterationId: String, inProject projectId: String = defaultProjectId, with imageUrl: ImageUrl, completion: @escaping (CustomVisionResponse<ImagePredictionResult>) -> Void) {
        
        let query = "iterationId=\(iterationId)"
        
        let request = dataRequest(for: .quickTestImageUrl(projectId: projectId), withBody: imageUrl, withQuery: query)
        
        return sendRequest(request, completion: completion)
    }
    
    public func trainProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        let request = dataRequest(for: .trainProject(projectId: projectId))
        
        return sendRequest(request, completion: completion)
    }
    
    
    
    fileprivate func sendRequest<T:Codable> (_ request: URLRequest, completion: @escaping (CustomVisionResponse<T>) -> ()) {
        
        session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if let error = error {
                
                completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .failure(error)))
                
            } else if let data = data {
                
                do {
                    
                    let resource = try self.decoder.decode(T.self, from: data)
                    
                    completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .success(resource)))
                    
                } catch {

                    completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .failure(error)))
                }
            } else {
                fatalError("fail")
            }
        }.resume()
    }
    
    fileprivate func dataRequest(for api: CustomVisionApi, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) -> URLRequest {
        return self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    fileprivate func dataRequest<T:Codable>(for api: CustomVisionApi, withBody body: T? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) -> URLRequest {
        
        if let body = body {
            
            do {
                
                let bodyData = try encoder.encode(body)
                
                return self.dataRequest(for: api, withBody: bodyData, withQuery: query, andHeaders: headers)
            
            } catch {
                print("::::: ❌ Error :::::\n\(error)")
                fatalError("failed to encode \(T.self)")
            }
        }
        
        return self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    fileprivate func _dataRequest(for api: CustomVisionApi, withBody body: Data? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) -> URLRequest {
        
        guard api.hasValidIds, !trainingKey.isEmpty
            else { fatalError("Must set projectId and trainingId in CustomVisionClient") }
        
        var urlString = scheme + host + basePath + api.path
        
        if let queryString = query, !queryString.isEmpty {
            urlString = urlString + "?" + queryString
        }
        
        let url = URL(string: urlString)!
        
        
        var request = URLRequest(url: url)
        
        request.httpMethod = api.method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(trainingKey, forHTTPHeaderField: "Training-key")
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        request.httpBody = body
        
        return request
    }
}

enum HttpMethod : String {
    case get    = "GET"
    case head   = "HEAD"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    
    var lowercased: String {
        switch self {
        case .get:      return "get"
        case .head:     return "head"
        case .patch:    return "patch"
        case .post:     return "post"
        case .put:      return "put"
        case .delete:   return "delete"
        }
    }
    
    var read: Bool {
        switch self {
        case .get, .head:           return true
        case .patch, .post, .put, .delete:  return false
        }
    }
    
    var write: Bool {
        return !read
    }
}
