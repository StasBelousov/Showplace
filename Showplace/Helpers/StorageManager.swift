//
//  StorageManager.swift
//  Showplace
//
//  Created by Станислав Белоусов on 01/05/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject (_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    static func deleteObject (_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
