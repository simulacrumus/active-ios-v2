//
//  ActivityTypeViewModel.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation
import Combine

class ActivityTypeViewModel: API{
    @Published var activityTypes:[ActivityType] = [ActivityType]()
    @Published var activityType:ActivityType? = nil
    @Published var sort:ActivityTypeSortEnum = .title
    @Published var searchTerm:String = String()
    @Published var fetchState: FetchState = .idle
    @Published var dataState: DataState = .initial
    
    private var categoryId:Int = Int.zero
    private var facilityId:Int = Int.zero
    private let size:Int = 10
    private var page:Int = Int.zero
    
    override init() {
        super.init()

        $searchTerm
          .dropFirst()
          .sink { [weak self] term in
              self?.fetchState = .idle
              self?.fetch(searchTerm: term.trim())
          }
          .store(in: &subscriptions)
        
        $sort
            .dropFirst()
            .debounce(for: .seconds(0.0), scheduler: RunLoop.main)
            .sink{ [weak self] sortOption in
                self?.fetchState = .idle
                self?.fetch(sort: sortOption)
            }
            .store(in: &subscriptions)
        // No need to fetch activity types when the object is initialzed
        // Fetch activity types only when user starts typing for search
    }
    
    init(sort:ActivityTypeSortEnum) {
        self.sort = sort
        super.init()
        self.fetch()
    }
    
    init(categoryId:Int){
        self.categoryId=categoryId
        super.init()
        self.fetch()
    }
    
    init(categoryId:Int, facilityId:Int){
        self.categoryId=categoryId
        self.facilityId=facilityId
        super.init()
        self.fetch()
    }
    
    init(activityTypeId:Int) {
        super.init()
        fetchActivityType(activityTypeId: activityTypeId)
    }
    
    func fetch(){
        let url = getURL(searchTerm: self.searchTerm, sort: self.sort, categoryId: self.categoryId, facilityId: self.facilityId)
        fetch(url: url)
    }
    
    private func fetch(sort:ActivityTypeSortEnum){
        let url = getURL(searchTerm: self.searchTerm, sort: sort, categoryId: self.categoryId, facilityId: self.facilityId)
        fetch(url: url)
    }
    
    private func fetch(searchTerm:String){
        let url = getURL(searchTerm: searchTerm, sort: self.sort, categoryId: self.categoryId, facilityId: self.facilityId)
        fetch(url: url)
    }
    
    private func fetch(url: URL){
        service.fetchActivityTypePage(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let activityTypePage):
                    self.activityTypes = activityTypePage.content
                    self.fetchState = activityTypePage.last ? .loadedAll : .idle
                    self.dataState = activityTypePage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
    }
    
    func fetchNextPage(){
        guard fetchState == .idle else {
            return
        }
        self.fetchState = .loading
        self.page += 1
        let url = getURL(searchTerm: self.searchTerm, sort: self.sort, categoryId: self.categoryId, facilityId: self.facilityId)
        service.fetchActivityTypePage(url: url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let activityTypePage):
                    self.activityTypes.append(contentsOf: activityTypePage.content)
                    self.activityTypes = self.activityTypes.uniqued() // API might response with duplicate items in different pages, which causes strange UI behaviour
                    self.fetchState = activityTypePage.last ? .loadedAll : .idle
                    self.dataState = activityTypePage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
    }
    
    func fetchActivityType(activityTypeId:Int){
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = "\(self.defaultPath)/types/\(activityTypeId)"
        
        guard let url = components.url else {
            return
        }
        
        service.fetchActivityType(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.dataState = .error(error.localizedDescription)
                case .success(let activityType):
                    self.activityType = activityType
                    self.dataState = .ok
                }
            }
        }
    }
    
    private func getURL(searchTerm:String, sort:ActivityTypeSortEnum, categoryId:Int, facilityId:Int) -> URL{
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "sort", value: sort.description),
            URLQueryItem(name: "page", value: self.page.description),
            URLQueryItem(name: "size", value: self.size.description),
        ]
        if(categoryId == Int.zero){
            if(facilityId == Int.zero){
                components.path = "\(self.defaultPath)/types"
                
            } else {
                components.path = "\(self.defaultPath)/facilities/\(facilityId)/types"
            }
        } else{
            if(facilityId == Int.zero){
                components.path = "\(self.defaultPath)/categories/\(categoryId)/types"
            } else {
                components.path = "\(self.defaultPath)/facilities/\(facilityId)/categories/\(categoryId)/types"
            }
        }
        return components.url!
    }
}
