//
//  PlayViewController.swift
//  SwiftMaps
//
//  Created by Yang Hu on 11/21/15.
//  Copyright © 2015 Brett Morgan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Parse
import AVFoundation



class PlayViewController: UIViewController , ESTBeaconManagerDelegate,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    

    var allRecords: [String] = []
    var audioPlayer: AVAudioPlayer?
    
    var timer = NSTimer()
    var counter = 0
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!,
        identifier: "blueberry")
    let placesByBeacons = [
        "583:38376": [
            "Heavenly Sandwiches": 50,
            "Green & Green Salads": 150,
            "Mini Panini": 325
        ],
        "648:12": [
            "Heavenly Sandwiches": 250,
            "Green & Green Salads": 100,
            "Mini Panini": 20
        ],
        "17581:4351": [
            "Heavenly Sandwiches": 350,
            "Green & Green Salads": 500,
            "Mini Panini": 170
        ]
    ]
    func placesNearBeacon(beacon: CLBeacon) -> [String] {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sort( { $0.1 < $1.1 }).map { $0.0 }
            return sortedPlaces
        }
        return []
    }
    
    func beaconManager(manager: AnyObject!, beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        print("ssss")
        if let nearestBeacon = beacons.first as? CLBeacon {
            let places = placesNearBeacon(nearestBeacon)
            // TODO: update the UI here
            print(places) // TODO: remove after implementing the UI
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestAlwaysAuthorization()
       
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
        
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
}