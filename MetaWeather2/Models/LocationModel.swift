//
//  LocationModel.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 7/2/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation

class Location: Decodable {

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
