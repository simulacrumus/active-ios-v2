//
//  APIError.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        // user feedback
        switch self {
            case .badURL, .parsing, .unknown:
                return NSLocalizedString("something_went_wrong", comment: "")
            case .badResponse(_):
                return NSLocalizedString("connection_failed", comment: "")
            case .url(let error):
                return error?.localizedDescription ?? NSLocalizedString("something_went_wrong", comment: "")
        }
    }
    
    var description: String {
        //info for debugging
        switch self {
            case .unknown: return "Unknown Error"
            case .badURL: return "Invalid URL"
            case .url(let error):
                return error?.localizedDescription ?? "URL Session Error"
            case .parsing(let error):
                return "Parsing Error \(error?.localizedDescription ?? "")"
            case .badResponse(statusCode: let statusCode):
                return "Bad Response With Status Code \(statusCode)"
        }
    }
}
