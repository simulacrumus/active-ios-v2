//
//  CategoryViewModel.swift
//  Active
//
//  Created by Emrah on 2022-12-23.
//

import Foundation
import Combine

class CategoryViewModel: API{
    @Published var categories = [Category]()
    @Published var fetchState: FetchState = .idle
    @Published var dataState: DataState = .initial
    @Published var searchTerm:String = String()
    @Published var facilityId:Int = Int.zero
//    @Published var category:Category? = nil
    
    private let size:Int = 100
    private var page:Int = Int.zero
    
    override init() {
        super.init()
        
        $searchTerm
          .dropFirst()
          .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
          .sink { [weak self] term in
              self?.fetchState = .idle
              self?.fetch(for: term.trim())
          }
          .store(in: &subscriptions)
        
        $facilityId
            .dropFirst()
            .sink{ [weak self] facilityId in
                self?.fetchState = .idle
                self?.fetch(for: facilityId)
            }
            .store(in: &subscriptions)
        
        fetch()
    }
    
    init(facilityId:Int){
        self.facilityId = facilityId
        super.init()
        fetch()
    }
    
    private func fetch(for facilityId:Int){
        let url = getURL(forQuery: self.searchTerm, forFacility: facilityId)
        fetch(url: url)
    }
    
    private func fetch(for query:String){
        let url = getURL(forQuery: query, forFacility: self.facilityId)
        fetch(url: url)
    }
    
    func fetch(){
        let url = getURL(forQuery: self.searchTerm, forFacility: self.facilityId)
        fetch(url: url)
    }
    
    private func fetch(url: URL){
        self.fetchState = .loading
        service.fetchCategoryPage(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let categoryPage):
                    self.categories = categoryPage.content
                    self.fetchState = categoryPage.last ? .loadedAll : .idle
                    self.dataState = categoryPage.totalElements == Int.zero ? .empty : .ok
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
        let url = getURL(forQuery: self.searchTerm, forFacility: self.facilityId)
        service.fetchCategoryPage(url: url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                    case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    case .success(let categoryPage):
                    self.categories.append(contentsOf: categoryPage.content)
                    self.categories = self.categories.uniqued() // API might response with duplicate items in different pages, which causes strange UI behaviour
                    self.fetchState = categoryPage.last ? .loadedAll : .idle
                    self.dataState = categoryPage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
    }
    
    private func getURL(forQuery searchTerm:String, forFacility facilityId:Int) -> URL{
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "page", value: self.page.description),
            URLQueryItem(name: "size", value: self.size.description)
        ]
        if(facilityId == Int.zero){
            components.path = "\(self.defaultPath)/categories"
        } else{
            components.path = "\(self.defaultPath)/facilities/\(facilityId)/categories"
        }

        return components.url!
    }
}
