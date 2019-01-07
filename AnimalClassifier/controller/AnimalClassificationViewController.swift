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
    
    override func viewDidLoad() {
        
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
    }
}
