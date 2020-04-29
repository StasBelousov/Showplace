//
//  MainViewController.swift
//  Showplace
//
//  Created by Станислав Белоусов on 29/04/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    
    let showplaceNames = ["Морской порт","Ресторан Дом","Сап Станция","Отель Пуллман"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showplaceNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = showplaceNames[indexPath.row]
        cell.imageView?.image = UIImage.init(named: showplaceNames[indexPath.row])
        
        return cell
    }
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

}
