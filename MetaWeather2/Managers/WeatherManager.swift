//
//  WeatherManager.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit

protocol WeatherManagerDelegate {
    func weatherChanged()
    func locationFound(_ location: String)
    func searchSaved()
    func fahrenheightToggle()
}

class WeatherManager: NSObject,ObservableObject{
    static let shared = WeatherManager()
    let gpsLocationManager = CLLocationManager()
    var gotLocation = false
    var latitude = ""
    var longitude = ""
    var delegate: WeatherManagerDelegate?{
        didSet{
            gpsLocationManager.delegate = self
            //Start GPS
            gpsLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            gpsLocationManager.requestWhenInUseAuthorization()
            gpsLocationManager.startUpdatingLocation()

        }
    }
    @Published private var currentCityName = ""
    @Published var loading = false
    @Published var farenHeight = true {
        didSet{
            delegate?.fahrenheightToggle()
        }
    }
    private var woeid = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @Published var results = [SearchResult]()
    @Published private var currentCityWeather:ConsolidatedWeather!
    private let defaultWeather = ConsolidatedWeather(id: 1, weather_state_name: "", weather_state_abbr: "", wind_direction_compass: "", applicable_date: "", min_temp: 1, max_temp: 1, the_temp: 1, wind_speed: 1, humidity: 1, predictability: 1)
    @Published  private var weatherForcast = [ConsolidatedWeather]()

    override init() {
        super.init()
        loadSearchResults()
    }


    func setCurrentCityWeather(_ weather:ConsolidatedWeather){
        DispatchQueue.main.async {
            self.currentCityWeather = weather
        }
    }

    func getCurrentCityWeather()->ConsolidatedWeather{
        if currentCityWeather == nil{
            return defaultWeather
        }
        return currentCityWeather
    }

    func setWeatherForecast(_ weatherForcast:[ConsolidatedWeather]){
        DispatchQueue.main.async {
            self.weatherForcast = weatherForcast
            self.delegate?.weatherChanged()
        }
    }

    func setWoeid(woeid:Int){
        self.woeid = woeid
    }
    func getCurrentCityName() -> String{
        return currentCityName
    }

    func refreshLocation(){
        gpsLocationManager.delegate = self
        gpsLocationManager.requestLocation()
    }

    func getWeatherForecast() -> [ConsolidatedWeather]{
        return weatherForcast
    }

    func getSearchHistory() -> [SearchResult]{
        return results
    }

    func fetchLocation(with latt:String, long:String, done: @escaping ()->()){
        Api.shared.fetchWithLattLong(latt: latt, long: long) {[weak self] (res: Result<[Location], Error>) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let loc):
                guard let location = loc.first else {
                    print("Couldnt find location")
                    done()
                    return
                }
                DispatchQueue.main.async {
                    self?.currentCityName = location.title
                    
                }
                self?.fetchWeather(with: location.woeid) {
                    done()
                }

            }
        }
    }
    func fetchWeather( with query:String, done: @escaping(Bool)->()){
        Api.shared.fetchWithQuery(query: query) { [weak self](res:Result<[Location], Error>) in
            switch res{
            case .failure(let err):
                print(err)
            case.success(let loc):
                guard let location = loc.first else {
                    print("Couldnt find location")
                    done(false)
                    return
                }
                DispatchQueue.main.async {
                    self?.currentCityName = location.title

                }
                guard let context = self?.context else {return}

                let newResult = SearchResult(context: context)
                newResult.title = query.capitalized
                newResult.woeid = Int64(location.woeid)
                newResult.timeStamp = getTimeStamp()
                newResult.type = location.location_type

                DispatchQueue.main.async {
                    self?.results.insert(newResult, at: 0)
                }
                self?.saveSearchResults()
                self?.delegate?.searchSaved()
                self?.fetchWeather(with: location.woeid) {
                    done(true)
                }
            }
        }
    }
    func fetchWeather(with woeid:Int,done: @escaping()->()){
        DispatchQueue.main.async {[weak self] in
            self?.loading.toggle()

        }
        Api.shared.fetchWeatherWithWoeid(woeid: woeid) { [weak self](res:Result<[ConsolidatedWeather],Error>) in

            DispatchQueue.main.async {
                self?.loading.toggle()
            }

            switch res{

            case .failure(let err):
                print(err)
            case .success(let consWeather):
                guard let currentCity = consWeather.first else {return}
                self?.setCurrentCityWeather(currentCity)
                self?.setWeatherForecast(consWeather)
                done()
            }
        }

    }

    func loadSearchResults() {
        //specify data type
        let request: NSFetchRequest<SearchResult> = SearchResult.fetchRequest()
        request.sortDescriptors =  [NSSortDescriptor(keyPath: \SearchResult.timeStamp, ascending: false)]
        fetchRequest(request: request)
    }
    
    func delete(at offsets: IndexSet){
        offsets.forEach { (index) in
            let search = self.results[index]
            context.delete(search)
        }
        try? context.save()
        loadSearchResults()
    }

    func saveSearchResults(){

        do{
            try context.save()

        }catch{
            print("error saving context \(error)")
        }

    }

    func fetchRequest(request: NSFetchRequest<SearchResult>){
        do {
            results = try context.fetch(request)
            print(results)
        } catch  {
            print("error \(error)")
        }

    }
}


extension WeatherManager: CLLocationManagerDelegate{

    // MARK: - location gps methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            gotLocation = true
            gpsLocationManager.stopUpdatingLocation()
            gpsLocationManager.delegate = nil
            print("longitude \(location.coordinate.longitude) latitude \(location.coordinate.latitude)")
            latitude = "\(location.coordinate.latitude)"
            longitude = "\(location.coordinate.longitude)"
            WeatherManager.shared.fetchLocation(with: latitude, long: longitude) {
                DispatchQueue.main.async {[weak self] in
                    self?.delegate?.locationFound( WeatherManager.shared.getCurrentCityName())
                }
                print("done")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
