//
//  WeatherCollectionViewController.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation
import Combine


private let reuseIdentifier = "Cell"
private let searchHistory = "SearchHistory"

class WeatherCollectionViewController: UICollectionViewController {
    var isFahrenheit = true
    let gpsLocationManager = CLLocationManager()
    
    
    init() {
        super.init(collectionViewLayout: WeatherCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var refresher:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .random()
        
        
        
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.white
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
        
        WeatherManager.shared.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(HostingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ForecastViewCell.self, forCellWithReuseIdentifier: ForecastViewCell.reuseIdentifier)
        self.collectionView.register(SearchHistoryViewCell.self, forCellWithReuseIdentifier: SearchHistoryViewCell.reuseIdentifier)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func refresh(){
        self.collectionView.refreshControl?.beginRefreshing()
        
        WeatherManager.shared.refreshLocation()
    }
    
    func stopRefresher() {
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return WeatherManager.shared.getWeatherForecast().count
        case 2:
            return 1
        default:
            return 2
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HostingCollectionViewCell else {
                fatalError("Cant do it")
            }
            
            cell.host(UIHostingController(rootView: CurrentWeatherView(woeid: 2383660).background(LinearGradient(gradient: Gradient(colors: [.init(.displayP3, white: 1, opacity: 0.12), .clear]), startPoint: .bottomLeading, endPoint: .topTrailing)).cornerRadius(20)))
            //            cell.backgroundColor = .clear
            //            cell.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
            //            cell.contentView.backgroundColor = .clear
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            cell.layer.shadowColor = UIColor.init(white: 0, alpha: 0.4).cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastViewCell.reuseIdentifier, for: indexPath) as? ForecastViewCell else {
                fatalError("Cant do it")
            }
            let weather = WeatherManager.shared.getWeatherForecast()[indexPath.row]
            //            cell.host(UIHostingController(rootView: ForecastView(weather: weather).background(LinearGradient(gradient: Gradient(colors: [.init(.displayP3, white: 1, opacity: 0.90), .clear]), startPoint: .bottomLeading, endPoint: .topTrailing)).cornerRadius(10)))
            cell.configure(with: weather)
            cell.backgroundColor = .clear
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchHistoryViewCell.reuseIdentifier, for: indexPath) as? SearchHistoryViewCell else {
                fatalError("Cant do it")
            }
            let results = WeatherManager.shared.getSearchHistory()
            cell.configureWith(searchHistory: results)
            cell.backgroundColor = .clear
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cell.backgroundColor = .white
            return cell
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else { fatalError() }
        switch indexPath.section {
        case 1:
            sectionHeader.title.text = "Forecast"
        case 2:
            sectionHeader.title.text = "Search History"
        default:
            break
        }
        return sectionHeader
    }
    
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        
        let layoutSectionSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return layoutSectionSectionHeader
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //    item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                //    item.contentInsets.bottom = 0
                group.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8 )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.bottom = 32
                
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 8
                item.contentInsets.bottom = 0
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(150)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.trailing = 8
                section.contentInsets.leading = 8
                section.contentInsets.bottom = 16
                let layoutSectionSectionHeader = self.createSectionHeader()
                
                section.boundarySupplementaryItems = [layoutSectionSectionHeader]
                
                
                return section
            case 2:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                //    item.contentInsets.trailing = 8
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                item.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
                group.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8 )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.bottom = 32
                let layoutSectionSectionHeader = self.createSectionHeader()
                
                section.boundarySupplementaryItems = [layoutSectionSectionHeader]
                
                
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 2
                item.contentInsets.bottom = 0
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        }
    }
    
    
}




struct WeatherCollectionViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




extension WeatherCollectionViewController: WeatherManagerDelegate{
    func fahrenheightToggle() {
        collectionView.reloadSections(IndexSet(integer: 1))
        
    }
    
    func searchSaved() {
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 2))
            
        }
    }
    
    func locationFound(_ location: String) {
        print(location)
        DispatchQueue.main.async {
            self.collectionView.backgroundColor = .random()
            
        }
        stopRefresher()
        
    }
    
    func weatherChanged() {
        DispatchQueue.main.async {
            self.collectionView.backgroundColor = .random()
            
        }
        collectionView.reloadSections(IndexSet(integer: 1))
    }
    
    
}


