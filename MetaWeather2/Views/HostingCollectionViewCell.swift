//
//  HostingCollectionViewCell.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/30/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import SwiftUI

class HostingCollectionViewCell: UICollectionViewCell {

    func host<Content: View>(_ hostingController: UIHostingController<Content>) {
        backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        addSubview(hostingController.view)

        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            hostingController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            hostingController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
