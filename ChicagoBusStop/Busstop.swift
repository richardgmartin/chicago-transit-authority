//
//  Busstop.swift
//  ChicagoBusStop
//
//  Created by Richard Martin on 2016-02-02.
//  Copyright © 2016 Richard Martin. All rights reserved.
//

import UIKit

class Busstop: NSObject {
    
    var latitude: Double
    var longitude: Double
    var stringLatitude: String
    var stringLongitude: String
    var stopName: String
    var direction: String
    var stopNumber: String
    var routes: String
    var addressURL: String
    //    var intermodal: String

    
    init(busStopDictionary: NSDictionary ) {
        
        self.stringLatitude = busStopDictionary["latitude"] as! String
        self.stringLongitude = busStopDictionary["longitude"] as! String
        self.latitude = Double(self.stringLatitude)!
        self.longitude = Double(self.stringLongitude)!
        self.stopName = busStopDictionary["cta_stop_name"] as! String
        self.direction = busStopDictionary["direction"] as! String
        self.stopNumber = busStopDictionary["stop_id"] as! String
        self.routes = busStopDictionary["routes"] as! String
        self.addressURL = busStopDictionary["_address"] as! String
        //        intermodal = busStopDictionary["inter_modal"] as! String

        
    }

}
