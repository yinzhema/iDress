//
//  PictureViewController.swift
//  iDress
//
//  Created by Yinzhe Ma on 12/2/19.
//  Copyright © 2019 Yinzhe Ma. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var moveOnButtonPressed: UIButton!
    
    var imagePicker=UIImagePickerController()
    var Outfits: Outfit!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Outfits==nil{
            Outfits = Outfit()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        Outfits.outfits.append(outfitStruct(image: selectedImage, type: "", vibe: "", warmth: 0, waterResistant: 0))
        picker.dismiss(animated: true, completion: nil)
        
        moveOnButtonPressed.isHidden=false
       
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        moveOnButtonPressed.isHidden=false
    }
    
    func showAlert(title: String, message: String){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction=UIAlertAction(title:"OK", style:.default, handler:nil)
        alertController.addAction(defaultAction)
        present(alertController,animated:true, completion: nil)
    }
    
    @IBAction func libraryPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate=self
        present(imagePicker,animated:true, completion:nil)
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.delegate=self
            present(imagePicker,animated:true, completion:nil)
        } else{
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="getQuestion"{
            let destinationNavighationController = segue.destination as! UINavigationController
            let destination = destinationNavighationController.topViewController as!QuestionViewController
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
