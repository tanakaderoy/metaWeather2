//
//  SearchHistoryView.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/30/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI

struct SearchHistoryView: View {
    init(results: [SearchResult]){
        self.results = results
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    var results: [SearchResult]
    var body: some View {
        List(results, id: \.woeid) { (res:SearchResult) in
            VStack(alignment:.leading) {
                Text(res.title ?? "No Content")
                Text(res.timeStamp?.toDate() ?? "")
            }.onTapGesture {
                WeatherManager.shared.fetchWeather(with: res.title ?? "") {_ in 
                    print("tapped")
                }
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [ .clear,.init(.displayP3, white: 1, opacity: 0.4)]), startPoint: .top, endPoint: .bottomLeading)).cornerRadius(10)
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(results: [SearchResult]())
    }
}



public class SearchHistoryViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchHistoryViewCell"
    var searchHistoryView: SearchHistoryView!
    var customView: UIHostingController<SearchHistoryView>?
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        customView?.view = UIView()
    }
    public override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    public func  configureWith(searchHistory: [SearchResult]){
        searchHistoryView = SearchHistoryView(results: searchHistory)
        customView = UIHostingController(rootView: searchHistoryView)
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
