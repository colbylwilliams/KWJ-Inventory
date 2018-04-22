//
//  CustomVisionResponse.swift
//  Inventory
//
//  Created by Colby L Williams on 4/13/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import Foundation

public struct CustomVisionResponse<T> {
    
    public let data: Data?
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let result: CustomVisionResult<T>
    
    public var error: Error? { return result.error }
    
    public var resource: T?  { return result.resource }
    
    public init(request: URLRequest?, data: Data?, response: HTTPURLResponse?, result: CustomVisionResult<T>) {
        self.request = request
        self.data = data
        self.response = response
        self.result = result
    }
    
    public init (_ resource: T) {
        self.init(request: nil, data: nil, response: nil, result: .success(resource))
    }
    
    public init (_ error: Error) {
        self.init(request: nil, data: nil, response: nil, result: .failure(error))
    }
}


public enum CustomVisionResult<T> {
    case success(T)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    public var isFailure: Bool { return !isSuccess }
    
    public var resource: T? {
        switch self {
        case .success(let resource): return resource
        case .failure: return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}


public extension CustomVisionResponse {
    
    public func printResponseData() {
        if let data = self.data {
            print("::::: Data :::::\n\(String(data: data, encoding: .utf8) ?? "fail")")
        } else {
            print("::::: Data :::::\nnil")
        }
    }
    public func printResult() {
        switch self.result {
        case let .success(resource): print("::::: ✅ Success :::::")
            if let resources = resource as? [CustomStringConvertible] {
                for r in resources { print(r) }
            } else {
                print(resource)
            }
        case let .failure(error): print("::::: ❌ Failure :::::\n\(error)")
        }
    }
}
