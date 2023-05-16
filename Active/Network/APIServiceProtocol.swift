//
//  APIServiceProtocol.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation

protocol APIServiceProtocol{
    
    func fetchActivityPage(url: URL?, completion: @escaping(Result<ActivityPage, APIError>) -> Void)
    
    func fetchFacilityPage(url: URL?, completion: @escaping(Result<FacilityPage, APIError>) -> Void)
    
    func fetchCategoryPage(url: URL?, completion: @escaping(Result<CategoryPage, APIError>) -> Void)
    
    func fetchActivityTypePage(url: URL?, completion: @escaping(Result<ActivityTypePage, APIError>) -> Void)
    
    func fetchFacility(url: URL?, completion: @escaping(Result<Facility, APIError>) -> Void)
    
    func fetchActivity(url: URL?, completion: @escaping(Result<Activity, APIError>) -> Void)
    
    func fetchActivityType(url: URL?, completion: @escaping(Result<ActivityType, APIError>) -> Void)
    
}
