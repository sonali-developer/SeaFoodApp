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
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var resultDisplayImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let inceptionV3Obj = Inceptionv3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        textLabel.isHidden = false
      
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                cameraImageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciImage)
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        guard let inceptionModel = try? VNCoreMLModel(for:inceptionV3Obj.model) else {
            fatalError("Loading CoreML Model failed")
        }
        let request = VNCoreMLRequest(model: inceptionModel) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation]
                else {
                fatalError("Model failed to process the image")
            }
           // print(results)
            guard let mostAccurateResult = results.first else {
                fatalError("Couldn't fetch first result from returned results array")
            }
            print(mostAccurateResult.identifier)
            if mostAccurateResult.identifier.contains("hotdog") {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Hot Dog"
                    //self.navigationController?.navigationBar.barTintColor = UIColor.green
                    //self.navigationController?.navigationBar.isTranslucent = false
                    
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    
                    self.resultDisplayImageView.image = UIImage(named: "HotDogYes")
                    
                }
                
                
            } else {
                DispatchQueue.main.async {
                    self.navigationItem.title = "Not A Hot Dog"
                    //self.navigationController?.navigationBar.barTintColor = UIColor.red
                    //self.navigationController?.navigationBar.isTranslucent = true
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
                    
                    self.resultDisplayImageView.image = UIImage(named: "HotDogNo")
                }
            }
            
        
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("Error performing VNRequest using handler \(error)")
        }
        
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        textLabel.isHidden = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

