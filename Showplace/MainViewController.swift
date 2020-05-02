//
//  MainViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 29/04/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var showPlaceArray: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlaceArray = realm.objects(Place.self)

    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showPlaceArray.isEmpty ? 0 : showPlaceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = showPlaceArray[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imagePlaceLabel.image = UIImage(data: place.imageData!)
        cell.imagePlaceLabel.layer.cornerRadius = cell.imagePlaceLabel.frame.size.height / 2
        cell.imagePlaceLabel.clipsToBounds = true
        
        return cell
    }
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = showPlaceArray[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
   // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place = showPlaceArray[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue (_ segue :UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
            
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
}
