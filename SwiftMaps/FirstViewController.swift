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
import AVFoundation


class FirstViewController: UIViewController ,CLLocationManagerDelegate{

    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var topLabel: UILabel!
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var player :AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
        marker.icon = UIImage(named:"allison.png")
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(42.057943, -87.677131)
        marker2.title = "Tech"
        marker2.map = mapView
        marker2.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
        
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(42.054080, -87.676642)
        marker3.title = "Kellogg"
        marker3.map = mapView
        marker3.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
        
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2DMake(42.050598, -87.678136)
        marker4.title = "Allison"
        marker4.map = mapView
        marker4.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
        
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2DMake(42.053313, -87.674816)
        marker5.title = "University Library"
        marker5.map = mapView
        marker5.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    
}

