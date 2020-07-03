//
//  ForecastViewCell.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/30/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import SwiftUI

public class ForecastViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ForecastViewCell"
    var forecastView: ForecastView!
    var customView: UIHostingController<ForecastView>?

    public override func prepareForReuse() {
        super.prepareForReuse()
        customView?.view = UIView()
    }
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }


     func configureWith(index: Int){
        
        forecastView = ForecastView(index: index)
        customView = UIHostingController(rootView: forecastView)
        customView!.view.translatesAutoresizingMaskIntoConstraints = false
        customView?.view.backgroundColor = .clear
        contentView.addSubview(customView!.view)

        customView!.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        customView!.view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        customView!.view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        customView!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//class ForecastViewCell: UICollectionViewCell {
//    static var reuseIdentifier = "ForecastViewCell"
//    @ObservedObject var weatherManager = WeatherManager.shared
//
//
//    let dateLabel = UILabel()
//    let maxTempLabel = UILabel()
//    let minTempLabel = UILabel()
//    let imageView = UIImageView()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
//        dateLabel.textColor = .secondaryLabel
//
//        maxTempLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 18,weight: .bold))
//        maxTempLabel.textColor = .label
//        minTempLabel.font = .preferredFont(forTextStyle: .callout)
//        minTempLabel.textColor = .secondaryLabel
//
//        let controller = UIHostingController(rootView: (LinearGradient(gradient: Gradient(colors: [.init(.displayP3, white: 1, opacity: 0.90), .clear]), startPoint: .bottomLeading, endPoint: .topTrailing)).cornerRadius(10))
//        controller.view.backgroundColor = .clear
//        backgroundView = controller.view
//
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = UIImage()
//    }
//
//    func configure(with weather:ConsolidatedWeather){
//        dateLabel.text = "\(weather.applicable_date.toDate())"
//        maxTempLabel.text = weatherManager.farenHeight ? "\(String(format: "%0.0f",weather.max_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weather.max_temp))°"
//        minTempLabel.text = weatherManager.farenHeight ? "\(String(format: "%0.0f",weather.min_temp.toFahrenheit()))°": "\(String(format: "%0.0f",weather.min_temp))°"
//        imageView.load(url: URL(string: "\(IMAGE_BASE_URL)\(weather.weather_state_abbr).png")!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        imageView.contentMode = .scaleAspectFit
//        let stackView = UIStackView(arrangedSubviews: [dateLabel, maxTempLabel, minTempLabel, imageView])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.spacing = 10
//        stackView.distribution = .equalSpacing
//        stackView.alignment = .center
//        addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
