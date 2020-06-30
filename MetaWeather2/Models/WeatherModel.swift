//
//  WeatherModel.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation

struct WeatherRoot: Codable {

    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
    let consolidatedWeather: [ConsolidatedWeather]


    enum CodingKeys: String, CodingKey {
        case title = "title"
        case location_type = "location_type"
        case woeid = "woeid"
        case latt_long = "latt_long"
        case consolidatedWeather = "consolidated_weather"
    }

}

struct ConsolidatedWeather: Codable {
    let id: Int
    let weather_state_name: String
    let weather_state_abbr: String
    let wind_direction_compass: String
    let applicable_date: String
    let min_temp: Double
    let max_temp: Double
    let the_temp: Double
    let wind_speed: Double
    let humidity: Int
    let predictability: Int

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case weather_state_name = "weather_state_name"
        case weather_state_abbr = "weather_state_abbr"
        case wind_direction_compass = "wind_direction_compass"
        case applicable_date = "applicable_date"
        case min_temp = "min_temp"
        case max_temp = "max_temp"
        case the_temp = "the_temp"
        case wind_speed = "wind_speed"
        case humidity = "humidity"
        case predictability = "predictability"

    }
}






// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}





class Location: Codable {

    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String


    enum CodingKeys: String, CodingKey {
        case title = "title"
        case location_type = "location_type"
        case woeid = "woeid"
        case latt_long = "latt_long"
    }

}
