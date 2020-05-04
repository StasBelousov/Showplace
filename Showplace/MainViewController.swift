//
//  MainViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 29/04/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var showPlaceArray: Results<Place>!
    private var filteredShowPlaceArray: Results<Place>!
    private var ascendingSorting = true
    private var searchBarIsEmpty:Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlaceArray = realm.objects(Place.self)
        
        // search setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredShowPlaceArray.count
        }
        
        return showPlaceArray.isEmpty ? 0 : showPlaceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var place = Place()
        if isFiltering {
           place = filteredShowPlaceArray[indexPath.row]
        } else {
            place = showPlaceArray[indexPath.row]
        }

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imagePlaceLabel.image = UIImage(data: place.imageData!)
        cell.imagePlaceLabel.layer.cornerRadius = cell.imagePlaceLabel.frame.size.height / 2
        cell.imagePlaceLabel.clipsToBounds = true
        
        if place.rating > 0 {
            cell.ratingLabel.text = "\(Int(place.rating))"
            cell.ratingImage.image = UIImage(systemName: "star.circle.fill")
        }
        
        return cell
    }
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
            var place: Place
            if isFiltering {
               place = filteredShowPlaceArray[indexPath.row]
            } else {
                place = showPlaceArray[indexPath.row]
            }
            
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue (_ segue :UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else {return}
            
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = UIImage(systemName: "arrow.down")
        } else {
            reversedSortingButton.image = UIImage(systemName: "arrow.up")
        }
        
        sorting()
    }
     
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            showPlaceArray = showPlaceArray.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            showPlaceArray = showPlaceArray.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
            
            tableView.reloadData()
        }

}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText (_ searchText: String) {
        
        filteredShowPlaceArray = showPlaceArray.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)

        tableView.reloadData()
    }
    
}
