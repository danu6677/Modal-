//
//  HotelData.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

struct Result:Codable {
    var status: Int?
    var data: [HotelData]?
}

struct HotelData: Codable {

    var id:Int?
    var title:String?
    var descriptionData:String?
    var address:String?
    var postcode:String?
    var phoneNumber:String?
    var latitude:String?
    var longitude:String?
    var image:Image?// this is a dictionary
    
}
struct Image:Codable {
    var small:String?
    var medium:String?
    var large:String?
}
