//
//  ForecastView.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI

struct ForecastView: View {
    @Environment(\.imageCache) var cache: ImageCache
    var weather: ConsolidatedWeather

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("\(weather.applicable_date.toDate())").font(.subheadline).foregroundColor(.secondary)
                Text("\(String(format: "%0.0f",weather.max_temp.toFahrenheit()))°").font(.callout).fontWeight(.bold).foregroundColor(.black)
                Text("\(String(format: "%0.0f",weather.min_temp.toFahrenheit()))°").font(.callout).foregroundColor(.secondary)
                AsyncImage(url: URL(string: "\(IMAGE_BASE_URL)\(weather.weather_state_abbr).png")!, placeholder: Image(systemName: "sun.min.fill").resizable().frame(width: 30.0, height: 30.0).foregroundColor(.yellow), cache: self.cache, width: 40, height: 40)
                Spacer()
            }
            Spacer()
        }
    }
}



struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(weather: .init(id: 1, weather_state_name: "", weather_state_abbr: "", wind_direction_compass: "", applicable_date: "2020-07-03", min_temp: 30, max_temp: 32, the_temp: 33, wind_speed: 10, humidity: 1, predictability: 10))
    }
}


