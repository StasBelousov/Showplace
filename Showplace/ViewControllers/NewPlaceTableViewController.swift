//
//  NewPlaceTableViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 01/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {
    
    var currentPlace: Place!
    var newPlaceImageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        nameTF.addTarget(self, action: #selector(nameTFCanged), for: .editingChanged)
        setupEditPlace()
        
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
    // MARK - Navigation
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
        guard
            let identifire = segue.identifier,
            let mapVC = segue.destination as? MapViewController
            else { return }
        
        mapVC.incomeSegueIdentifier = identifire
        mapVC.mapViewControllerDelegate = self
        
        if identifire == "showMap" {
        mapVC.place.name = nameTF.text!
        mapVC.place.location = locationTF.text
        mapVC.place.type = typeTF.text
        mapVC.place.imageData = placeImage.image?.pngData()
       }
    }
    
    private func setupEditPlace() {
        if currentPlace != nil {
            
            setupNavigationBar()
            newPlaceImageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            nameTF.text = currentPlace?.name
            locationTF.text = currentPlace?.location
            typeTF.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    private func setupNavigationBar() {
        if let backItem = navigationController?.navigationBar.topItem {
            backItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        saveButton.isEnabled = true
        title = currentPlace?.name
        navigationItem.leftBarButtonItem = nil
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
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func savePlace () {
    
        let image = newPlaceImageIsChanged ? placeImage.image : UIImage(systemName: "camera.on.rectangle.fill")
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: nameTF.text!,
                             location: locationTF.text,
                             type: typeTF.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.rating = newPlace.rating
                }
        } else {
                StorageManager.saveObject(newPlace)
        }
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
extension NewPlaceTableViewController: MapViewControllerDelegate {
   
    func getAddress(_ address: String?) {
        locationTF.text = address
    }
}
