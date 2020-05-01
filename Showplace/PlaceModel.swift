//
//  PlaceModel.swift
//  Showplace
//
//  Created by Станислав Белоусов on 30/04/2020.
//  Copyright © 2020 Станислав Белоусов. All rights reserved.
//

import UIKit

struct Place {
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var placeImage: String?
    
    
    static let showplaceNames = ["Морской порт","Ресторан Дом","Сап Станция","Отель Пуллман"]
    
    static func getPlaces() -> [Place] {
        var places = [Place]()
        
        for place in showplaceNames {
            places.append(Place(name: place, location: "Sochi", type: "Showplace", image: nil, placeImage: place))
        }
        
        return places
    }
}
