//
//  EndViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/4/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    var Outfits: Outfit!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="aNewDay"{
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!VibeViewController
            destination.Outfits=Outfits
        }
    }
    
//    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
//        saveToUserDefaults()
//    }
    
//    func saveToUserDefaults(){
//        let encoder=JSONEncoder()
//        if let encoded=try? encoder.encode(Outfits){
//            UserDefaults.standard.set(encoded, forkey:"Outfits")
//        } else{
//            print("ERROR: Saving encoded didn't work")
//        }
//    }
    
}
