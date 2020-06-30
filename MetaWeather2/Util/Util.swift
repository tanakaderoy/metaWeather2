//
//  Util.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import Foundation
import UIKit
func showAlert(alert: UIAlertController) {
    if let controller = topMostViewController() {
        controller.present(alert, animated: true)
    }
}

private func keyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
    .filter {$0.activationState == .foregroundActive}
    .compactMap {$0 as? UIWindowScene}
    .first?.windows.filter {$0.isKeyWindow}.first
}

private func topMostViewController() -> UIViewController? {
    guard let rootController = keyWindow()?.rootViewController else {
        return nil
    }
    return topMostViewController(for: rootController)
}

private func topMostViewController(for controller: UIViewController) -> UIViewController {
    if let presentedController = controller.presentedViewController {
        return topMostViewController(for: presentedController)
    } else if let navigationController = controller as? UINavigationController {
        guard let topController = navigationController.topViewController else {
            return navigationController
        }
        return topMostViewController(for: topController)
    } else if let tabController = controller as? UITabBarController {
        guard let topController = tabController.selectedViewController else {
            return tabController
        }
        return topMostViewController(for: topController)
    }
    return controller
}


//trim whitespace from string beggining and end
extension String {
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func toDate() -> String{
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "YYYY-MM-DD"
        let date = formatter4.date(from: self)
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "EEE d"
        let today = formatter3.string(from: Date())
        if self == "2020-06-30"{
            return "Today"
        }
        return  formatter3.string(from: date ?? Date()) == today ? "Today" : formatter3.string(from: date ?? Date())
    }
}
//turns celcius to fahrenheit
extension Double {
    func toFahrenheit() -> Double {
        return self * 9 / 5 + 32
    }
    
}

func getTimeStamp() -> String {
      // get the current date and time
      let currentDateTime = Date()

      // initialize the date formatter and set the style
      let formatter = DateFormatter()
      formatter.timeStyle = .short
      formatter.dateStyle = .short

      // get the date time String from the date object
      return formatter.string(from: currentDateTime)
  }


let IMAGE_BASE_URL = "https://www.metaweather.com/static/img/weather/png/"

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


// MARK: - URLSession response handlers

extension URLSession {
    func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }

            do {
                let decoded = try newJSONDecoder().decode(T.self, from: data)
                completionHandler(decoded,response,nil)
            }catch{
                completionHandler(nil,response,error)
            }

        }
    }

    func WeatherResponseTask(with url: URL, completionHandler: @escaping (WeatherRoot?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
    func LocationResponseTask(with url: URL, completionHandler: @escaping ([Location]?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
