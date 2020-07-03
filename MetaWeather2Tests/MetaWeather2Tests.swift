//
//  MetaWeather2Tests.swift
//  MetaWeather2Tests
//
//  Created by Tanaka Mazivanhanga on 7/3/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//
import XCTest
@testable import MetaWeather2

class MetaWeather2Tests: XCTestCase {
    let locationJSON =  "[\n" +
                       "  {\n" +
                       "    \"distance\": 1516,\n" +
                       "    \"title\": \"San Francisco\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2487956,\n" +
                       "    \"latt_long\": \"37.777119, -122.41964\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 12030,\n" +
                       "    \"title\": \"Oakland\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2463583,\n" +
                       "    \"latt_long\": \"37.80508,-122.273071\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 51870,\n" +
                       "    \"title\": \"Mountain View\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2455920,\n" +
                       "    \"latt_long\": \"37.39999,-122.079552\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 67872,\n" +
                       "    \"title\": \"San Jose\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2488042,\n" +
                       "    \"latt_long\": \"37.338581,-121.885567\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 96326,\n" +
                       "    \"title\": \"Santa Cruz\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2488853,\n" +
                       "    \"latt_long\": \"36.974018,-122.030952\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 118989,\n" +
                       "    \"title\": \"Sacramento\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2486340,\n" +
                       "    \"latt_long\": \"38.579060,-121.491013\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 247299,\n" +
                       "    \"title\": \"Lake Tahoe\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 23511744,\n" +
                       "    \"latt_long\": \"39.021400,-120.044823\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 259448,\n" +
                       "    \"title\": \"Fresno\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2407517,\n" +
                       "    \"latt_long\": \"36.740681,-119.785728\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 405545,\n" +
                       "    \"title\": \"Bakersfield\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2358492,\n" +
                       "    \"latt_long\": \"35.351189,-119.024063\"\n" +
                       "  },\n" +
                       "  {\n" +
                       "    \"distance\": 558894,\n" +
                       "    \"title\": \"Los Angeles\",\n" +
                       "    \"location_type\": \"City\",\n" +
                       "    \"woeid\": 2442047,\n" +
                       "    \"latt_long\": \"34.053490,-118.245323\"\n" +
                       "  }\n" +
                       "]"


    func testLocationDecodingSuccess() throws {
        let jsonDecoder = JSONDecoder()
        let location = try jsonDecoder.decode([Location].self, from: locationJSON.data(using: .utf8)!)
        XCTAssertNotNil(location)
        XCTAssertEqual(location.count, 10)
        guard let loc = location.first else {return assertionFailure()}
        XCTAssertEqual(loc.title, "San Francisco")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }


}
