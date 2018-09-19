//
//  ViewController.swift
//  SeaFoodApp
//
//  Created by Sonali Patel on 9/19/18.
//  Copyright © 2018 Sonali Patel. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                cameraImageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

