//
//  OutfitSelectionViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/4/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit

class OutfitSelectionViewController: UIViewController {

    var top=[outfitStruct]()
    var bottom=[outfitStruct]()
    var Outfits:Outfit!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    var count=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count=top.count
        print(count)
        topImageView.image=top[count-1].image
        bottomImageView.image=bottom[count-1].image
        // Do any additional setup after loading the view.
    }
    
    @IBAction func topNextButtonPressed(_ sender: UIButton) {
        nextOutfit()
    }
    
    
    @IBAction func bottomNextButtonPressed(_ sender: UIButton) {
        nextOutfit()
    }
    
    func nextOutfit(){
        let length=top.count
        if (count<length-1){
            count=count+1
            topImageView.image=top[count].image
            bottomImageView.image=bottom[count].image
        } else{
            count=0
            topImageView.image=top[count].image
            bottomImageView.image=bottom[count].image
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="getLastPage"{
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!EndViewController
            destination.Outfits=Outfits
        }
    }
    
    

}
