//
//  ViewController.swift
//  MyZoo
//
//  Created by Caleb Stultz on 8/3/18.
//  Copyright © 2018 Caleb Stultz. All rights reserved.
//

import UIKit
import CoreML
import Vision

class AnimalClassificationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLbl: UILabel!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: AnimalClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                // process classification
                self.processClassifictaion(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to laod model")
        }
    }()
    
    func processClassifictaion(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let classifictaion =  request.results as? [VNClassificationObservation] else {
                self.classificationLbl.text = "Unable to classify image"
                return
            }
            
            if classifictaion.isEmpty {
                self.classificationLbl.text = "Nothing Recognized"
            } else {
                let topClassification = classifictaion.prefix(2)
                let description = topClassification.map { classifictaions in
                    return String(format: "%.2f", classifictaions.confidence * 100) + "% -" + classifictaions.identifier
                    
                }
                self.classificationLbl.text = "Classifications:\n" + description.joined(separator: "\n")
            }
        }
      
    }
    
    func updateClassification(for image: UIImage) {
        classificationLbl.text = "Classifying ..."
        guard let orienation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)),let ciImage = CIImage(image: image) else {
            displayError()
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(ciImage: ciImage , orientation: orienation)
            do {
                try handler.perform([self.classificationRequest])
                
            }catch {
                print("Failed to perform classification")
            }
        }
       
    }
    
    func displayError() {
        classificationLbl.text = "Something went wrong...\nPlease try again"
    }
    
    @IBAction func cameraBtnWasPressed(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        photoSourcePicker.addAction(takePhotoAction)
        photoSourcePicker.addAction(choosePhotoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        photoSourcePicker.addAction(cancelAction)
        present(photoSourcePicker, animated: true, completion: nil)
}

    func presentPhotoPicker(sourceType : UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }

}

extension AnimalClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("No Image Returned")
        }
        imageView.image = image
        updateClassification(for: image)
    }
}
