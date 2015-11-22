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
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var distance: UILabel!
    var allRecords: [String] = []
    var audioPlayer: AVAudioPlayer?
    var player :AVPlayer!
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
    func updateCounter() {
  
        print ("it is 5 seconds dude")
        let query = PFQuery(className: "Buyers")
        //query.selectKeys(["Name"])
        query.whereKey("Name", equalTo:"Norris")
        var objects :[PFObject] = []
        var selected :String!
        do{
            objects = try query.findObjects() as [PFObject]
            let randomNumber = arc4random_uniform(UInt32(objects.count))
            let another = objects[Int(randomNumber)] as PFObject?
            print(randomNumber)
            
            let record = another!["records"] as! PFFile
            //print(record.url)
            selected = record.url
            
            //selected = "http://files.parsetfss.com/292b6f11-5fee-4be7-b317-16fd494dfa3d/tfss-ccc3a843-967b-4773-b92e-1cf2e8f3c1c6-testfile.wav"
            var myURL: String?
            print("selected:")
            print(selected)
            let playerItem = AVPlayerItem( URL:NSURL( string: selected )! )
            player = AVPlayer(playerItem:playerItem)
            //player.rate = 1.0;
            player.volume = 1.0
            player.play()
            
            
        }catch{
            print(error)
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        
        let query = PFQuery(className: "Buyers")
        //query.selectKeys(["Name"])
        query.whereKey("Name", equalTo:"Norris")
        var objects :[PFObject] = []
        var selected :String!
        do{
            objects = try query.findObjects() as [PFObject]
            let randomNumber = arc4random_uniform(UInt32(objects.count))
            let another = objects[Int(randomNumber)] as PFObject?
            print(randomNumber)
            
            let record = another!["records"] as! PFFile
            //print(record.url)
            selected = record.url
            
            //selected = "http://files.parsetfss.com/292b6f11-5fee-4be7-b317-16fd494dfa3d/tfss-ccc3a843-967b-4773-b92e-1cf2e8f3c1c6-testfile.wav"
            var myURL: String?
            print("selected:")
            print(selected)
            let playerItem = AVPlayerItem( URL:NSURL( string: selected )! )
            player = AVPlayer(playerItem:playerItem)
            //player.rate = 1.0;
            player.volume = 1.0
            player.play()
            
            
        }catch{
            print(error)
        }

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