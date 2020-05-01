//
//  NewPlaceTableViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 01/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    
    var newPlace: Place?
    var newPlaceImageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        
        nameTF.addTarget(self, action: #selector(nameTFCanged), for: .editingChanged)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = UIImage(systemName: "camera.fill")
            let photoIcon = UIImage(systemName: "photo.fill")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default){ _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                
            }
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
}
// MARK - Text field delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    // hide keyboard button DONE pressed
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func nameTFCanged() {
        if nameTF.text?.isEmpty == false {
            saveButton.isEnabled = true
        }else {
            saveButton.isEnabled = false
        }
    }
    
    func saveNewPlace () {
        
        var image: UIImage?
        
        if newPlaceImageIsChanged {
            image = placeImage.image
        } else {
            image = UIImage(systemName: "camera.on.rectangle.fill")
        }
        
        newPlace = Place(name: nameTF.text!,
                         location: locationTF.text,
                         type: typeTF.text,
                         image: image,
                         placeImage: nil)
    }
}
// MARK - Image
extension NewPlaceTableViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
     
        if UIImagePickerController.isSourceTypeAvailable(source) {
           let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        newPlaceImageIsChanged = true
        dismiss(animated: true)
    }
   
}
