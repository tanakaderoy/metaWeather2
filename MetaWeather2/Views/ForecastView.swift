//
//  ForecastView.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var weatherManager = WeatherManager.shared
    var index : Int
    var weather: ConsolidatedWeather!

    init(index: Int) {
        self.index = index
        weather = weatherManager.getWeatherForecast()[index]
    }

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("\(weather.applicable_date.toDate())").font(.subheadline).foregroundColor(.secondary)
                Text(weatherManager.farenHeight ? "\(String(format: "%0.0f",weather.max_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weather.max_temp))°").font(.callout).fontWeight(.bold).foregroundColor(.black)
                Text(weatherManager.farenHeight ? "\(String(format: "%0.0f",weather.min_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weather.min_temp))°").font(.callout).foregroundColor(.secondary)
                Image(uiImage: UIImage(named: weather.weather_state_abbr)!).resizable().frame(width: 40, height: 40)

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


