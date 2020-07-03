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
    @ObservedObject var weatherManager = WeatherManager.shared
    var index : Int
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("\(weatherManager.getWeatherForecast()[index].applicable_date.toDate())").font(.subheadline).foregroundColor(.secondary)
                Text(weatherManager.farenHeight ? "\(String(format: "%0.0f",weatherManager.getWeatherForecast()[index].max_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weatherManager.getWeatherForecast()[index].max_temp))°").font(.callout).fontWeight(.bold).foregroundColor(.black)
                Text(weatherManager.farenHeight ? "\(String(format: "%0.0f",weatherManager.getWeatherForecast()[index].min_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weatherManager.getWeatherForecast()[index].min_temp))°").font(.callout).foregroundColor(.secondary)
                AsyncImage(url: URL(string: "\(IMAGE_BASE_URL)\(weatherManager.getWeatherForecast()[index].weather_state_abbr).png")!, placeholder: Text(""), cache: self.cache, width: 40, height: 40)
                Spacer()
            }
            Spacer()
        }  .background(LinearGradient(gradient: Gradient(colors: [ .clear,.init(.displayP3, white: 1, opacity: 0.4)]), startPoint: .top, endPoint: .bottomLeading)).cornerRadius(10)
    }
}



struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(index: 1)
    }
}


