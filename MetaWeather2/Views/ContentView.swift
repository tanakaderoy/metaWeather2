//
//  ContentView.swift
//  MetaWeather2
//
//  Created by Tanaka Mazivanhanga on 6/29/20.
//  Copyright © 2020 Tanaka Mazivanhanga. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var alertInput = ""
    @ObservedObject var maneger = WeatherManager.shared

    var body: some View {
        NavigationView{
            Container().edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Weather", displayMode: .large)
                .navigationBarItems(leading:
                    Button(maneger.farenHeight ? "F°": "C°") {
                        self.maneger.farenHeight.toggle()
                    }.foregroundColor(.secondary),trailing:Button("Search"){
                        self.alert()
                    }.foregroundColor(.secondary)
            )
        }
    }
    private func alert() {
        let alert = UIAlertController(title: "Search For City", message: "Major City Please", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search for major city"
        }

       alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
        self.alertInput = textField.text ?? "Name"
        WeatherManager.shared.fetchWeather(with: self.alertInput) {(done:Bool) in
            switch done{
            case true:
                print("Finished")
            case false:
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Try Again", message: "Couldn't Find City", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    showAlert(alert: alert)

                }

            }

        }
        print(self.alertInput)
        })
        showAlert(alert: alert)
    }

    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) ->  UIViewController {
            return  WeatherCollectionViewController()
        }

        func updateUIViewController(_ uiViewController:  UIViewController, context: Context) {

        }
        typealias UIViewControllerType = UIViewController

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
