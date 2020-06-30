//
//  CurrentWeatherView.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI

struct CurrentWeatherView: View {
    var woeid:Int
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var weatherManager = WeatherManager.shared
    @State var isLoading = false
    var body: some View {
        LoadingView(isShowing: $weatherManager.loading){
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 10){
                    HStack(alignment: .top) {
                        if self.weatherManager.getCurrentCityWeather().weather_state_abbr == "" {

                        }

                        else{
                            if self.weatherManager.farenHeight{

                                Text("\(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().the_temp.toFahrenheit()))°").fontWeight(.heavy).font(.largeTitle).foregroundColor(Color.init(.label))
                            }else{
                                Text("\(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().the_temp))°").fontWeight(.heavy).font(.largeTitle).foregroundColor(Color.init(.label))
                            }
                            AsyncImage(url: URL(string: "\(IMAGE_BASE_URL)\(self.weatherManager.getCurrentCityWeather().weather_state_abbr).png")!, placeholder: Image(systemName: "sun.min.fill").resizable().frame(width: 30.0, height: 30.0).foregroundColor(.yellow), cache: self.cache, width: 40, height: 40)

                        }

                    }

                    Text(self.weatherManager.getCurrentCityWeather().weather_state_name)
                        .foregroundColor(Color.init(.label))
                    Spacer()


                }
                .padding(.top)
                Spacer()
                Text(self.weatherManager.getCurrentCityName()).foregroundColor(Color.init(.label)).padding(.top, 20)
                Spacer()
                VStack(alignment: .trailing) {
                    if self.weatherManager.getCurrentCityWeather().weather_state_abbr == "" {

                    }else{
                        Text("\(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().wind_speed)) mph \(self.weatherManager.getCurrentCityWeather().wind_direction_compass)").foregroundColor(Color.init(.label)).padding(.bottom, 5)
                        if self.weatherManager.farenHeight{
                            Text("\(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().max_temp.toFahrenheit()))° / \(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().min_temp.toFahrenheit()))°")
                                .foregroundColor(Color.init(.label))
                        }else{
                            Text("\(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().max_temp))° / \(String(format: "%0.0f", self.weatherManager.getCurrentCityWeather().min_temp))°")
                                .foregroundColor(Color.init(.label))
                        }
                        Spacer()
                    }
                }
                .padding(.top)

            }.padding(.horizontal).background(Color.clear)
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(woeid: 2383660)
    }
}
