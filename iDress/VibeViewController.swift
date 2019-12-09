//
//  VibeViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/4/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class VibeViewController: UIViewController {
    
    
    @IBOutlet var vibeButtonPressed: [UIButton]!
    @IBOutlet weak var showOutfitButton: UIButton!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var weather: weatherInfo!
    var Outfits:Outfit!
    var top:[outfitStruct]!
    var bottom:[outfitStruct]!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!

    let urlBase="https://api.darksky.net/forecast/"
    let urlAPIKey="a0cfa57977540ed55de49665365703e8/"
    var coordinates=""
    
    struct vibeCheck {
        var vibe=""
        var top=false
        var bottom=false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideVibes()
        top=[]
        bottom=[]
        weather=weatherInfo(rain: 0, temp: 0)
        getLocation()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sportyButtonPressed(_ sender: UIButton) {
        filterOutfit(vib: "Sporty")
        vibeButtonPressed[0].setTitle("Sporty it is!", for: .normal)
        vibeButtonPressed[0].isEnabled=false
        vibeButtonPressed[1].isHidden=true
        vibeButtonPressed[2].isHidden=true
        vibeButtonPressed[3].isHidden=true
        cancelButton.isEnabled=false
        
    }
    
    @IBAction func coolButtonPressed(_ sender: UIButton) {
        filterOutfit(vib: "Cool")
        vibeButtonPressed[1].setTitle("Cool it is!", for: .normal)
        vibeButtonPressed[1].isEnabled=false
        vibeButtonPressed[0].isHidden=true
        vibeButtonPressed[2].isHidden=true
        vibeButtonPressed[3].isHidden=true
        cancelButton.isEnabled=false
    }
    
    @IBAction func classicButtonPressed(_ sender: UIButton) {
        filterOutfit(vib: "Classic")
        vibeButtonPressed[2].setTitle("Classic it is!", for: .normal)
        vibeButtonPressed[2].isEnabled=false
        vibeButtonPressed[0].isHidden=true
        vibeButtonPressed[1].isHidden=true
        vibeButtonPressed[3].isHidden=true
        cancelButton.isEnabled=false
    }
    
    
    @IBAction func formalButtonPressed(_ sender: UIButton) {
        filterOutfit(vib: "Formal")
        vibeButtonPressed[3].setTitle("Formal it is!", for: .normal)
        vibeButtonPressed[3].isEnabled=false
        vibeButtonPressed[0].isHidden=true
        vibeButtonPressed[1].isHidden=true
        vibeButtonPressed[2].isHidden=true
        cancelButton.isEnabled=false
    }
    
    func hideVibes(){
        var counter=0
        var vibeChecks=[vibeCheck]()
        let vibe=["Sporty","Cool", "Classic", "Formal"]
        for i in 0...3{
            vibeChecks.append(vibeCheck(vibe: vibe[i], top: false, bottom: false))
        }
        for element in Outfits.outfits{
            for i in 0...vibeChecks.count-1 {
                if element.vibe==vibeChecks[i].vibe{
                    if element.type=="Top"{
                        vibeChecks[i].top=true
                    } else{
                        vibeChecks[i].bottom=true
                    }
                }
            }
        }
        for i in 0...vibeChecks.count-1 {
            if !vibeChecks[i].bottom || !vibeChecks[i].top {
                vibeButtonPressed[i].isHidden=true
                counter=counter+1
            }
        }
        
        if counter>1 && counter<3 {
            explanationLabel.isHidden=false
        } else if counter==3{
            explanationLabel.text="We are only showing the vibe that is availabe😢"
            explanationLabel.isHidden=false
        }
        
        if vibeButtonPressed[0].isHidden && vibeButtonPressed[1].isHidden && vibeButtonPressed[2].isHidden && vibeButtonPressed[3].isHidden {
            showOutfitButton.isHidden=true
            showAlert(title: "Not Enought Outfit", message: "Sorry, you don't have enough outfits for us to give recommendation! Store more!")
        }
    }
    
    func showAlert(title: String, message: String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction=UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController,animated:true, completion: nil)
    }
    
    func filterOutfit(vib: String){
        let scaledTemp=Int(weather.temp)/10
        let warmLevelNeeded=10-scaledTemp
        for element in Outfits.outfits{
            if element.vibe==vib && element.type=="Top"{
                if weather.rain==1{
                    if element.waterResistant==1{
                        top.append(element)
                    }
                } else{
                    top.append(element)
                }
            } else if element.vibe==vib && element.type=="Bottom" {
                bottom.append(element)
            }
        }

        top=sortArray(array: &top, warmLevelNeeded: warmLevelNeeded)
        bottom=sortArray(array: &bottom, warmLevelNeeded: warmLevelNeeded)
    }
    
    func sortArray(array: inout [outfitStruct],warmLevelNeeded:Int)-> [outfitStruct] {
        var min=100
        var temp: outfitStruct!
        let length=array.count
        var newArray=[outfitStruct]()
        var counter = -1
        for _ in 0...length-1{
            for element in array {
                counter=counter+1
                if abs(Int(element.warmth)-warmLevelNeeded)<=min{
                    min=abs(Int(element.warmth)-warmLevelNeeded)
                    temp=element
                }
            }
            array.remove(at: counter)
            newArray.append(temp)
            min=100
            counter=0
        }
        return newArray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showOutfit"{
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!OutfitSelectionViewController
            destination.top=top
            destination.bottom=bottom
            destination.Outfits=Outfits
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode=presentingViewController is UINavigationController
        if isPresentingInAddMode{
            dismiss(animated: true, completion: nil)
        } else{
            navigationController!.popViewController(animated: true)
        }
    }
    
    func getWeather(){
        let weatherURL=urlBase+urlAPIKey+coordinates
        Alamofire.request(weatherURL).responseJSON{ (response) in
            switch response.result{
            case .success(let value):
                let json=JSON(value)
                if let maxTemperature=json["daily"]["data"][0]["temperatureHigh"].double, let minTemperature=json["daily"]["data"][0]["temperatureLow"].double{
                    let avgTemperature=(maxTemperature+minTemperature)/2
                    self.weather.temp=avgTemperature
                }
                if let rain = json["daily"]["data"][0]["precipProbability"].double{
                    if rain>0.5 {
                        self.weather.rain=1
                    } else{
                        self.weather.rain = -1
                    }
                }
            case .failure(let error):
                print(error)
            }

        }
    }
}

extension VibeViewController: CLLocationManagerDelegate {
    
    func getLocation(){
        locationManager=CLLocationManager()
        locationManager.delegate=self
        let status=CLLocationManager.authorizationStatus()
        handleLocationAuthorizationStatus(status: status)
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("Can't show location.")
        case .restricted:
            print("Access denied.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation=locations.last
        let currentLatitude=currentLocation.coordinate.latitude
        let currentLongitude=currentLocation.coordinate.longitude
        let currentCoordinates="\(currentLatitude),\(currentLongitude)"
        coordinates=currentCoordinates
        getWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}

