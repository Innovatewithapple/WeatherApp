//
//  ViewController.swift
//  My weather
// admin by Mihir Vyas
//  Created by admin on 18/06/19.
//  Copyright © 2019 professional. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "fd8d7fc556c618da7eeb32dfaa115249"
    var lat = 11.3445334
    var lon = 104.3322
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 20.0)
        activityIndicator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
    if let responseStr = response.result.value {
        let jsonResponse = JSON(responseStr)
        let jsonWeather = jsonResponse["weather"].array![0]
        let jsonTemp = jsonResponse["main"]
        let iconName = jsonWeather["icon"].stringValue
        
        
        self.locationLabel.text = jsonResponse["name"].stringValue
        self.conditionImageView.image = UIImage(named: iconName)
        self.conditionLabel.text = jsonWeather["main"].stringValue
        self.tempratureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
        
        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
            self.dayLabel.text = dateFormatter.string(from: date)
        
        
        let suffix = iconName.suffix(1)
        if(suffix == "n"){
            self.setGreyGradientBackground()
        }else {
           
            self.setBlueGradientBackground()
        }
        
        }
    }
        
}
    
   
    
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
}

