//
//  TransitionViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/4/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit

class TransitionViewController: UIViewController {
    
    var Outfits:Outfit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let count=Outfits.outfits.count
        print(count)
        print(Outfits.outfits[count-1])
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="getVibe" {
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!VibeViewController
            destination.Outfits=Outfits
        } else if segue.identifier=="getAnother"{
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!PictureViewController
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
    

}
