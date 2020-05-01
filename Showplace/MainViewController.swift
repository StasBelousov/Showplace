//
//  MainViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 29/04/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    
    var showPlaceArray = Place.getPlaces()
    //let showplaceNames = ["Морской порт","Ресторан Дом","Сап Станция","Отель Пуллман"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showPlaceArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = showPlaceArray[indexPath.row]

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        if place.image == nil {
            cell.imagePlaceLabel.image = UIImage.init(named: place.placeImage!)
        } else {
            cell.imagePlaceLabel.image = place.image
        }
        

        cell.imagePlaceLabel.layer.cornerRadius = cell.imagePlaceLabel.frame.size.height / 2
        cell.imagePlaceLabel.clipsToBounds = true
        
        return cell
    }
    // MARK: - Table view delegate
    
    
    
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

    
    @IBAction func unwindSegue (_ segue :UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
            
        newPlaceVC.saveNewPlace()
        showPlaceArray.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }
}
