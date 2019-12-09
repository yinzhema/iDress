//
//  QuestionViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/4/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var typeSegementedControl: UISegmentedControl!
    @IBOutlet weak var waterResistantSegmentedControl: UISegmentedControl!
    @IBOutlet weak var warmthSlider: UISlider!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let waterResistantArray=[1,-1]
    let vibe=["Sporty","Cool", "Classic", "Formal"]
    let type=["Top","Bottom"]
    var Outfits:Outfit!
    var outfitsCount=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled=false
        outfitsCount=Outfits.outfits.count
        imageView.image=Outfits.outfits[outfitsCount-1].image
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func savedButtonPressed(_ sender: UIButton) {
    Outfits.outfits[outfitsCount-1].waterResistant=waterResistantArray[waterResistantSegmentedControl.selectedSegmentIndex]
        Outfits.outfits[outfitsCount-1].vibe=vibe[segmentedControl.selectedSegmentIndex]
        Outfits.outfits[outfitsCount-1].warmth=Int(warmthSlider.value)
        Outfits.outfits[outfitsCount-1].type=type[typeSegementedControl.selectedSegmentIndex]
        saveButton.setTitle("Saved!", for: .normal)
        doneButton.isEnabled=true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="goTransition" {
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!TransitionViewController
            destination.Outfits=Outfits
            print("Current outfit: \(Outfits.outfits[outfitsCount-1])")
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
