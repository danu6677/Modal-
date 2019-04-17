//
//  Config.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit

class Config: NSObject {
    public static var versionNumber = "" //MARK: - routing to relavant end-points handled from the back-end
    private static let DEV_BASE_URL = "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/"
    private static let PROD_BASE_URL = "https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/"
    
    
    public static var GET_HOTELS_DATA = DEV_BASE_URL+versionNumber+"hotels.json"
}
