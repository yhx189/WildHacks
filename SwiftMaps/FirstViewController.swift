//import UIKit
//import GoogleMaps
//
//class ViewController: UIViewController {
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    let mapView = self.view as! GMSMapView
//    mapView.camera = GMSCameraPosition.cameraWithLatitude(-33.8600, longitude: 151.2094, zoom: 10)
//  }
//
//}

import UIKit
import GoogleMaps
import Parse




class FirstViewController: UIViewController ,CLLocationManagerDelegate, ESTBeaconManagerDelegate{

    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var topLabel: UILabel!
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!,
        identifier: "ranged region")

    let placesByBeacons = [
        "538:38376": [
            "Norris": 50, // read as: it's 50 meters from
            // "Heavenly Sandwiches" to the beacon with
            // major 6574 and minor 54631
            "Tech": 150,
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
    func beaconManager(manager: AnyObject!,  beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            if let nearestBeacon = beacons.first as? CLBeacon {
                let places = placesNearBeacon(nearestBeacon)
                // TODO: update the UI here
                
                
                print(places) // TODO: remove after implementing the UI
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let inRange = delegate.inNorris
        
        print ("are you in range??")
        print(inNorris)
        
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        let camera = GMSCameraPosition.cameraWithLatitude(42.055984,
            longitude: -87.675171, zoom: 15.5)
        if camera != nil{
            mapView.camera = camera
        }
        
        //        let mapView = GMSMapView.mapWithFrame(rect, camera: camera)
        mapView.myLocationEnabled = true
        //self.view = actaulView
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(42.053442, -87.672761)
        marker.title = "Norris"
        marker.map = mapView
        marker.icon = UIImage(named:"norris (2).png")
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(42.057943, -87.677131)
        marker2.title = "Tech"
        marker2.map = mapView
        marker2.icon = UIImage(named:"tech.png")
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(42.054080, -87.676642)
        marker3.title = "Kellogg"
        marker3.map = mapView
        marker3.icon = UIImage(named:"kellogg.png")
        
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2DMake(42.050598, -87.678136)
        marker4.title = "Allison"
        marker4.map = mapView
        marker4.icon = UIImage(named:"allison-2.png")
        
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2DMake(42.053313, -87.674816)
        marker5.title = "University Library"
        marker5.map = mapView
        marker5.icon = UIImage(named:"mian library-2.png")
        
        
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

