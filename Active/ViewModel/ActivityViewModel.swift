//
//  ActivitiesViewModel.swift
//  Active
//
//  Created by Emrah on 2022-12-02.
//

import Foundation
import CoreLocation

class ActivityViewModel: API{
    @Published var activities = [Activity]()
    @Published var facilityId:Int = Int.zero
    @Published var sort:ActivitySortEnum = .distance
    @Published var searchTerm:String = String()
    @Published var isAvailable:Bool? = nil
    @Published var date:Date? = nil
    @Published var fetchState: FetchState = .idle
    @Published var dataState: DataState = .initial
    @Published var activity:Activity? = nil
    
    private var activityTypeId:Int = Int.zero
    
    private let locationManager = CLLocationManager()
    private let size:Int = 10
    private var page:Int = Int.zero
    
    override convenience init() {
        self.init(facilityId: Int.zero, activityTypeId: Int.zero)
    }
    
    convenience init(activityTypeId:Int) {
        self.init(facilityId: Int.zero, activityTypeId: activityTypeId)
    }
    
    init(facilityId:Int, activityTypeId:Int) {
        self.facilityId = facilityId
        self.activityTypeId = activityTypeId
        
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
              self?.fetch()
          }
          .store(in: &subscriptions)
        
        $sort
            .dropFirst()
            .sink{ [weak self] sortOption in
                self?.fetchState = .idle
                self?.fetch(sort: sortOption)
            }
            .store(in: &subscriptions)
        
        $facilityId
            .dropFirst()
            .sink{ [weak self] facilityId in
                self?.fetchState = .idle
                self?.fetch(facilityId: facilityId)
            }
            .store(in: &subscriptions)
        
        $isAvailable
            .dropFirst()
            .sink{ [weak self] available in
                self?.fetchState = .idle
                self?.fetch(isAvailable: available)
            }
            .store(in: &subscriptions)
        
        $date
            .dropFirst()
            .sink{ [weak self] datetime in
                self?.fetchState = .idle
                self?.fetch(date: datetime)
            }
            .store(in: &subscriptions)
        
        fetch()
        
        locationManager.stopUpdatingLocation()
    }
    
    init(activityId:Int){
        super.init()
        fetchActivity(activityId: activityId)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    func fetch(){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: self.facilityId, activityTypeId: self.activityTypeId, isAvailable: self.isAvailable, time: self.date)
        fetch(url: url)
    }
    
    private func fetch(isAvailable:Bool?){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: self.facilityId, activityTypeId: self.activityTypeId, isAvailable: isAvailable, time: self.date)
        fetch(url: url)
    }

    private func fetch(query:String){
        self.page = Int.zero
        let url = getURL(query: query, sort: self.sort, facilityId: self.facilityId, activityTypeId: self.activityTypeId, isAvailable: self.isAvailable, time: self.date)
        fetch(url: url)
    }

    private func fetch(facilityId:Int){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: facilityId, activityTypeId: self.activityTypeId, isAvailable: self.isAvailable, time: self.date)
        fetch(url: url)
    }

    private func fetch(sort:ActivitySortEnum){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: sort, facilityId: self.facilityId, activityTypeId: self.activityTypeId, isAvailable: self.isAvailable, time: self.date)
        fetch(url: url)
    }

    private func fetch(activityTypeId:Int){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: self.facilityId, activityTypeId: activityTypeId, isAvailable: self.isAvailable, time: self.date)
        fetch(url: url)
    }
    
    private func fetch(date:Date?){
        self.page = Int.zero
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: self.facilityId, activityTypeId: activityTypeId, isAvailable: self.isAvailable, time: date)
        fetch(url: url)
    }
    
    private func fetch(url: URL){
        self.fetchState = .loading
        locationManager.startUpdatingLocation()
        service.fetchActivityPage(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let activityPage):
                    self.activities = activityPage.content
                    self.fetchState = activityPage.last ? .loadedAll : .idle
                    self.dataState = activityPage.totalElements == Int.zero ? .empty : .ok
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
        self.page += 1 //Increment page number for next page
        let url = getURL(query: self.searchTerm, sort: self.sort, facilityId: self.facilityId, activityTypeId: self.activityTypeId, isAvailable: self.isAvailable, time: self.date)
        service.fetchActivityPage(url: url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.fetchState = .error(error.localizedDescription)
                    self.dataState = .error(error.localizedDescription)
                case .success(let activityPage):
                    self.activities.append(contentsOf: activityPage.content)
                    self.activities = self.activities.uniqued() // API might response with duplicate items in different pages, which causes strange UI behaviour
                    self.fetchState = activityPage.last ? .loadedAll : .idle
                    self.dataState = activityPage.totalElements == Int.zero ? .empty : .ok
                }
            }
        }
    }
    
    private func getURL(query:String, sort:ActivitySortEnum, facilityId:Int, activityTypeId:Int, isAvailable:Bool?, time:Date?) -> URL{
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "lat", value: self.userLocation.lastKnownLocation.lat.description),
            URLQueryItem(name: "lng", value: self.userLocation.lastKnownLocation.lng.description),
            URLQueryItem(name: "page", value: self.page.description),
            URLQueryItem(name: "size", value: self.size.description),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sort.description),
            URLQueryItem(name: "available", value: isAvailable?.description),
            URLQueryItem(name: "time", value: time?.localDateTimeString)
        ]
        if facilityId == Int.zero{
            if activityTypeId == Int.zero{
                components.path = "\(self.defaultPath)/activities"
            } else {
                components.path = "\(self.defaultPath)/types/\(activityTypeId.description)/activities"
            }
        } else if activityTypeId == Int.zero {
            components.path = "\(self.defaultPath)/facilities/\(facilityId.description)/activities"
        } else {
            components.path = "\(self.defaultPath)/facilities/\(facilityId.description)/types/\(activityTypeId.description)/activities"
        }
        return components.url!
    }
    
    func fetchActivity(activityId:Int){
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.queryItems = [
            URLQueryItem(name: "lat", value: self.userLocation.lastKnownLocation.lat.description),
            URLQueryItem(name: "lng", value: self.userLocation.lastKnownLocation.lng.description)
        ]
        components.path = "\(self.defaultPath)/activities/\(activityId)"
        
        guard let url = components.url else {
            return
        }
        
        service.fetchActivity(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.dataState = .error(error.localizedDescription)
                case .success(let activity):
                    self.activity = activity
                    self.dataState = .ok
                }
            }
        }
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
