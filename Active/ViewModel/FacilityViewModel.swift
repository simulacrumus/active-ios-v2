//
//  FacilityViewModel.swift
//  Active
//
//  Created by Emrah on 2022-12-30.
//

import Foundation
import CoreLocation

class FacilityViewModel: API{
    @Published var facilities = [Facility]()
    @Published var facility:Facility? = nil
    @Published var sort:FacilitySortEnum = .distance
    @Published var searchTerm:String = String()
    @Published var activityTypeId:Int = Int.zero
    @Published var fetchState: FetchState = .idle
    @Published var dataState: DataState = .initial
    
    private let locationManager = CLLocationManager()
    private var size:Int = 10
    private var page:Int = Int.zero
    
    override convenience init() {
        self.init(activityTypeId: Int.zero)
    }
    
    init(activityTypeId:Int) {
        self.activityTypeId = activityTypeId
        
        if activityTypeId != Int.zero{
            self.size = 1000
            self.sort = .title
        }
        
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        $searchTerm
          .dropFirst()
          .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
          .sink { [weak self] term in
              self?.fetchState = .idle
              self?.fetch(query: term.trim())
          }
          .store(in: &subscriptions)
        
        $sort
            .dropFirst()
            .sink{ [weak self] sortOption in
                self?.fetchState = .idle
                self?.fetch(sort: sortOption)
            }
            .store(in: &subscriptions)
        
        fetch()
    }
    
    init(facilityId:Int){
        super.init()
        fetch(facilityId: facilityId)
    }
    
    func fetch(){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, activityTypeId: self.activityTypeId)
        fetch(url: url)
    }
    
    private func fetch(query:String){
        self.page = Int.zero
        let url = getURL(query: query, sort: self.sort, activityTypeId: self.activityTypeId)
        fetch(url: url)
    }
    
    private func fetch(sort:FacilitySortEnum){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: sort, activityTypeId: self.activityTypeId)
        fetch(url: url)
    }
    
    private func fetch(url: URL){
        locationManager.startUpdatingLocation()
        self.fetchState = .loading
        service.fetchFacilityPage(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let facilityPage):
                    self.facilities = facilityPage.content
                    self.fetchState = facilityPage.last ? .loadedAll : .idle
                    self.dataState = facilityPage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func fetchNextPage(){
        guard fetchState == .idle else {
            return
        }
        self.fetchState = .loading
        self.page += 1
        let url = getURL(query: self.searchTerm, sort: self.sort, activityTypeId: self.activityTypeId)
        service.fetchFacilityPage(url: url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let facilityPage):
                    self.facilities.append(contentsOf: facilityPage.content)
                    self.facilities = self.facilities.uniqued() // API might response with duplicate items in different pages, which causes strange UI behaviour
                    self.fetchState = facilityPage.last ? .loadedAll : .idle
                    self.dataState = facilityPage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
    }
    
    func fetch(facilityId:Int){
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "lat", value: self.userLocation.lastKnownLocation.lat.description),
            URLQueryItem(name: "lng", value: self.userLocation.lastKnownLocation.lng.description)
        ]
        components.path = "\(self.defaultPath)/facilities/\(facilityId)"
        
        guard let url = components.url else {
            return
        }
        
        service.fetchFacility(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.dataState = .error(error.localizedDescription)
                    self.fetchState = .error(error.localizedDescription)
                case .success(let facility):
                    self.facility = facility
                    self.fetchState = .loadedAll
                    self.dataState = .ok
                }
            }
        }
    }
    
    private func getURL(query:String, sort:FacilitySortEnum, activityTypeId:Int) -> URL{
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "lat", value: self.userLocation.lastKnownLocation.lat.description),
            URLQueryItem(name: "lng", value: self.userLocation.lastKnownLocation.lng.description),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sort.description),
            URLQueryItem(name: "page", value: self.page.description),
            URLQueryItem(name: "size", value: self.size.description)
        ]
        
        if activityTypeId == Int.zero {
            components.path = "\(self.defaultPath)/facilities"
        } else {
            components.path = "\(self.defaultPath)/types/\(activityTypeId)/facilities"
        }
        return components.url!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation.updateLastKnownLocation(locations.last ?? userLocation.getLastKnownLocation())
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            manager.startUpdatingLocation()
            userLocation.updateLastKnownLocation(locationManager.location ?? userLocation.getLastKnownLocation())
            fetch()
            manager.stopUpdatingLocation()
        }
    }
}
