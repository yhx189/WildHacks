
import UIKit
import GoogleMaps
import Parse
import AVFoundation




class FirstViewController: UIViewController ,CLLocationManagerDelegate, ESTBeaconManagerDelegate{
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var topLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!,
        identifier: "ranged region")
    
    
    var beacons : AnyObject = []
    var timer = NSTimer()
    var popover: UIPopoverController? = nil
    
    var inNorris = true
    var inAllison = false
    var inKellogg = false
    var inTech  = false
    var inLibrary = false
    var cnt :Int = 0
    var counter = 0
    @IBOutlet var enterRegion: UIView!
    @IBOutlet var enterRegionContent: UILabel!
    //@IBOutlet var thisTitle: UILabel!
    //@IBOutlet var content: UILabel!
    
    var stopped = false
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopAudio(sender: AnyObject) {
        
        if stopped == false{
            player.rate = 0.0
            stopButton.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
            stopped = true
        } else{
            player.rate = 1.0
            stopButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
            stopped = false
        }
        
    }
    //@IBOutlet weak var enterRegion: UIView!
    @IBOutlet var shareStory: UIButton!
    var player :AVPlayer!
    var queuePlayer :AVQueuePlayer!
    //@IBOutlet weak var thisTitle: UILabel!
    //@IBOutlet weak var content: UILabel!
    
    
    @IBAction func shareStory(sender: AnyObject) {
        
        let popoverContent = (self.storyboard?.instantiateViewControllerWithIdentifier("RecordBoard"))! as UIViewController
        stopped = true 
        
        popoverContent.modalPresentationStyle = .Popover
        //var popover = popoverContent.popoverPresentationController
        
        let popover = popoverContent.popoverPresentationController
        
        let viewForSource = sender as! UIView
        popover!.sourceView = viewForSource
        
        // the position of the popover where it's showed
        popover!.sourceRect = viewForSource.bounds
        
        // the size you want to display
        popoverContent.preferredContentSize = CGSizeMake(200,500)
        //popover.delegate = self
        
        
        self.presentViewController(popoverContent, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    /*
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
    
    func updateView(note: NSNotification!){
    beacons = note.object!
    print("beacons:")
    print(beacons)
    
    }
    
    func beaconManager(manager: AnyObject!,  beacons: [AnyObject]!,
    inRegion region: CLBeaconRegion!) {
    if let nearestBeacon = beacons.first as? CLBeacon {
    let places = placesNearBeacon(nearestBeacon)
    // TODO: update the UI here
    
    
    print(places) // TODO: remove after implementing the UI
    }
    }
    
    */
    func updateCounter() {
        
        print ("it is 5 seconds dude")
        counter++
        if counter == 5{
            timer.invalidate()
            let query = PFQuery(className: "Buyers")
        var location :String = ""
        if (inNorris){
            location = "Norris"
        }
        if (inTech){
            location = "Tech"
        }
        if (inLibrary){
            location = "Library"
        }
        if (inAllison){
            location = "Allison"
        }
        if (inKellogg){
            location = "Kellogg"
        }
        if(!inNorris && !inTech && !inLibrary && !inAllison && !inKellogg){
            location = "Norris"
            }
        
        query.whereKey("Name", equalTo:location)
        query.whereKey("John", equalTo:false)
        var objects :[PFObject] = []
        /*
        var selected :String!
        if !player{
            objects = try query.findObjects() as [PFObject]
            let randomNumber = arc4random_uniform(UInt32(objects.count))
            let another = objects[Int(randomNumber)] as PFObject?
            print(randomNumber)
            
            let record = another!["records"] as! PFFile
            //print(record.url)
            selected = record.url
            print("selected:")
            print(selected)
            let playerItem = AVPlayerItem( URL:NSURL( string: selected )! )
            player = AVPlayer(playerItem:playerItem)
            //player.rate = 1.0;
            player.volume = 1.0
            if stopped == false{
                player.rate = 1.0
                player.play()
            }
            
        }catch{
            print("error")
        }
        
    }*/
        var selected :String!
        do{
            objects = try query.findObjects() as [PFObject]
            //let randomNumber = arc4random_uniform(UInt32(objects.count))
            //let randomNumer = cnt
            //let another = objects[Int(randomNumber)] as PFObject?
            //print(randomNumber)
            
            //let record = another!["records"] as! PFFile
            //print(record.url)
            var playerQueue :[AVPlayerItem] = []
            
            //selected = record.url
            //print("selected:")
            //print(selected)
            for object in objects{
                let record = object["records"] as! PFFile
                let thisRecord = record.url
                let playerItem = AVPlayerItem( URL:NSURL( string: thisRecord! )! )
                playerQueue.append(playerItem)
            }
            queuePlayer = AVQueuePlayer(items: playerQueue)
            
                
                if stopped == false{
                    queuePlayer.volume = 1.0
                    queuePlayer.rate = 1.0
                    queuePlayer.play()
                
                }
            
            
            
        }catch{
            print(error)
        }
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.hidden = true
        //        recordView.hidden = true
        enterRegion.hidden = true
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.beacons = delegate.beacons
        print("getting beacons ")
        
        self.inNorris = delegate.inNorris
        if let beaconStrings = self.beacons as? [String] {
            print(beaconStrings)
            for beacon in beaconStrings {
                
                print(beacon)
                if beacon.rangeOfString("CF1A5302") != nil{
                    print("find beacon in norris")
                    //inNorris = true
                }
                
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateView", name: "updateBeaconTableView", object: nil)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        
        
        let query = PFQuery(className: "Buyers")
        //query.selectKeys(["Name"])
        var location :String = ""
        if (inNorris){
            location = "Norris"
        }
        if (inTech){
            location = "Tech"
        }
        if (inLibrary){
            location = "Library"
        }
        if (inAllison){
            location = "Allison"
        }
        if (inKellogg){
            location = "Kellogg"
        }
        if(!inNorris && !inTech && !inLibrary && !inAllison && !inKellogg){
            location = "Norris"
        }
        
        query.whereKey("Name", equalTo:location)
        query.whereKey("John", equalTo:true)
        var objects :[PFObject] = []
        var selected :String!
        do{
            objects = try query.findObjects() as [PFObject]
            let randomNumber = arc4random_uniform(UInt32(objects.count))
            //let randomNumber = UInt32(objects.count)
            let another = objects[Int(randomNumber)] as PFObject?
            print(randomNumber)
            
            let record = another!["records"] as! PFFile
            //print(record.url)
            selected = record.url
            
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
        
        
        //let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        beacons = delegate.beacons
        
        print(beacons)
        
        print ("are you in range??")
        print(inNorris)
        
        
        let fontSize = self.topLabel.font.pointSize;
        self.topLabel.font = UIFont(name: "Coolvetica", size: fontSize)
        
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
        marker3.icon = UIImage(named:"kellogg-2.png")
        
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
        
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let inNorris = delegate.inNorris
        
        if (inNorris){
            topLabel.text = "Norris Student Center"
            
            bottomView.hidden = false
        }
//            enterRegion.hidden = false
//            
//            enterRegionContent.text = "Norris University Center is the student center where a lot of events are held. Come do art projects in Artica, hang out in the game room, or get your NU swag downstairs in the bookstore."
//            enterRegionContent.numberOfLines = 3
//            enterRegionContent.preferredMaxLayoutWidth = 500
//            enterRegionContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        }

        if (inTech){
            topLabel.text = "Tech Institute"
        }
        if (inLibrary){
            topLabel.text = "University library"
        }
        if (inAllison){
            topLabel.text = "Allison Hall"
        }
        if (inKellogg){
            topLabel.text = "Kellogg Center"
        }
        
        if(inAllison || inKellogg || inTech || inLibrary || inNorris){
            bottomView.hidden = false
        } else {
            bottomView.hidden = true
        }
        /*
        if(inAllison || inKellogg || inTech || inLibrary || inNorris){
            
            if (inAllison) {
                enterRegion.hidden = false
                thisTitle.text = "Allison Residential Hall"
                content.text = "Allsion res hall is considered one of the best on campus. It houses 300+ students and also includes a dinning hall. From burgers to pasta to ethnic food, there’s a different option every day. Also features a kosher and vegan bar."
            }
            if(inKellogg) {
                enterRegion.hidden = false
                thisTitle.text = "Kellogg School of Management"
                content.text = "The Kellogg building is the headquarters of the Kellogg School of Business. Many business or econ classes are offered there, along with a lot of graduate classes."
            }
            if(inTech){
                enterRegion.hidden = false
                thisTitle.text = "Technological Institute"
                content.text = "Tech is home to many science and engineering classes. Some people even turn classrooms into study rooms when they’re not being used."
            }
            if(inLibrary){
                enterRegion.hidden = false
                thisTitle.text = "University Library"
                content.text = "The University Library is the largest library on campus, and a great quiet spot to study. You can often find students passed out in the study carrels at 3AM during finals week."
            }
            
            
            if(inNorris){
                enterRegion.hidden = false
                thisTitle.text = "Norris"
                content.text = "Norris University Center is the student center where a lot of events are held. Come do art projects in Artica, hang out in the game room, or get your NU swag downstairs in the bookstore."
                print(" IN NORRIS")
            }
        } else {
            enterRegion.hidden = true
        }
        */
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    
}

