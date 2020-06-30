//
//  Api.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation


class Api {

    static let shared = Api()



    func fetchWeatherWithWoeid(woeid: Int, completion: @escaping (Result<[ConsolidatedWeather], Error>)->()){
        var urlComponents = URLComponents(string: "https://www.metaweather.com")


        urlComponents?.path = "/api/location/\(woeid)"
        guard let url = urlComponents?.url else { completion(.failure(NetworkingError.urlError("failed to get url")))
            return
        }
        print(url)
        let task = URLSession.shared.WeatherResponseTask(with: url) { (weatherRoot, resp, err) in
            if let err = err{
                completion(.failure(err))
            }
            if let weatherRoot = weatherRoot {
                completion(.success(weatherRoot.consolidatedWeather))
            }else{
                completion(.failure(NetworkingError.decodeError("location search")))
            }
        }
        task.resume()
    }

    func fetchWithLattLong(latt:String,long:String, completion: @escaping(Result<[Location],Error>)->()){
        var urlComponents = URLComponents(string: "https://www.metaweather.com")
        urlComponents?.path = "/api/location/search/"
        let queryItems = [URLQueryItem(name: "lattlong", value: "\(latt),\(long)")]

        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { completion(.failure(NetworkingError.urlError("failed to get url")))
            return
        }
        print(url)
        let task = URLSession.shared.LocationResponseTask(with: url) { (location, resp, err) in
            if let err = err{
                completion(.failure(err))
            }
            if let location = location{
                completion(.success(location))
            }else{
                completion(.failure(NetworkingError.decodeError("latt long search")))
            }
        }
        task.resume()
    }

    func fetchWithQuery(query:String, completion: @escaping(Result<[Location],Error>)->()){
        var urlComponents = URLComponents(string: "https://www.metaweather.com")
        urlComponents?.path = "/api/location/search/"

        let queryItems = [URLQueryItem(name: "query", value: "\(query)")]

        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { completion(.failure(NetworkingError.urlError("failed to get url")))
            return
        }
        print(url)
        let task = URLSession.shared.LocationResponseTask(with: url) { (location, resp, err) in
            if let err = err{
                completion(.failure(err))
            }
            if let location = location{
                completion(.success(location))
            }else{
                completion(.failure(NetworkingError.decodeError("latt long search")))
            }
        }
        task.resume()
    }
}


enum NetworkingError:Error{
    case urlError(String)
    case decodeError(String)
}
