//
//  APIService.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation
import SwiftUI


struct APIService: APIServiceProtocol {

    func fetch<T: Decodable>(_ type: T.Type, url: URL?, completion: @escaping(Result<T,APIError>) -> Void) {
        guard let url = url else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(type, from: data)
                    completion(Result.success(result))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }
            }
        }
        task.resume()
    }
    
    func fetchActivityPage(url: URL?, completion: @escaping (Result<ActivityPage, APIError>) -> Void) {
        fetch(ActivityPage.self, url: url, completion: completion)
    }
    
    func fetchFacilityPage(url: URL?, completion: @escaping (Result<FacilityPage, APIError>) -> Void) {
        fetch(FacilityPage.self, url: url, completion: completion)
    }
    
    func fetchCategoryPage(url: URL?, completion: @escaping (Result<CategoryPage, APIError>) -> Void) {
        fetch(CategoryPage.self, url: url, completion: completion)
    }
    
    func fetchActivityTypePage(url: URL?, completion: @escaping (Result<ActivityTypePage, APIError>) -> Void) {
        fetch(ActivityTypePage.self, url: url, completion: completion)
    }
    
    func fetchFacility(url: URL?, completion: @escaping (Result<Facility, APIError>) -> Void) {
        fetch(Facility.self, url: url, completion: completion)
    }
    
    func fetchActivity(url: URL?, completion: @escaping (Result<Activity, APIError>) -> Void) {
        fetch(Activity.self, url: url, completion: completion)
    }
    
    func fetchActivityType(url: URL?, completion: @escaping (Result<ActivityType, APIError>) -> Void) {
        fetch(ActivityType.self, url: url, completion: completion)
    }
}
