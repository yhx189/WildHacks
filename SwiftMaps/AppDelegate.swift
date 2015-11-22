import UIKit
import GoogleMaps
import Parse
import Bolts
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,ESTBeaconManagerDelegate{
    
    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    let locationManager = CLLocationManager()
    
    var inNorris :Bool = false
    var beacons = []
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!, identifier: "blueberry")
    
    let beaconRegion2 = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "ranging region")
    
    let beaconRegion3 = CLBeaconRegion( proximityUUID: NSUUID(UUIDString : "8492E75F-4FD6-469D-B132-043FE94932D8")!,identifier : "tech")
    
    var enteredRegion :Bool = false
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            // "Stories avaiable for this yoursTruly location"?
        "You've reached a yoursTruly location!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // See https://developers.google.com/maps/documentation/ios/start#obtaining_an_api_key
        GMSServices.provideAPIKey("AIzaSyDHcwyIq8uSWGsCmts9I_vzAlZMr_C6nBw")
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        // Northwestern beascons all share the UIUD of B9407F30-F5F8-466E-AFF9-25556B57FE6D.
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString : "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!,
            major : 538, minor : 38376, identifier : "monitored region"))
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion( proximityUUID: NSUUID(UUIDString : "8492E75F-4FD6-469D-B132-043FE94932D8")!, major : 10773, minor : 8349, identifier : "tech"))
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: .Alert, categories: nil))
        
        Parse.enableLocalDatastore()
        
        
        print("did enter background")
        inNorris = true
        
        
        // Initialize Parse.
        Parse.setApplicationId("rh45K7o7xlkEsxTyKRbw7az2jeFNdTqvunowGrFc",
            clientKey: "R8lw2NeO6cx9d021hpJGLLfXV6pBVYCygW6TSCBh")
        return true
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        enteredRegion = true
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        enteredRegion = false
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion){
        self.beacons = beacons
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeacon", object: self.beacons)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
            
        case .AuthorizedAlways:
            
            locationManager.startMonitoringForRegion(beaconRegion)
            locationManager.startRangingBeaconsInRegion(beaconRegion)
            locationManager.requestStateForRegion(beaconRegion)
            locationManager.startMonitoringForRegion(beaconRegion2)
            locationManager.startRangingBeaconsInRegion(beaconRegion2)
            locationManager.requestStateForRegion(beaconRegion2)
            locationManager.startMonitoringForRegion(beaconRegion3)
            locationManager.startRangingBeaconsInRegion(beaconRegion3)
            locationManager.requestStateForRegion(beaconRegion3)
            
        case .Denied:
            
            let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        default:
            print("default case")
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch state {
            
        case .Unknown:
            print("unknown")
            
        case .Inside:
            print("inside")
            var text : String = ""
            
            if enteredRegion {
                text = "You have entered the region of Norris "
            }
            Notifications.display(text)
            
        case .Outside:
            
            var text : String = ""
            
            if !enteredRegion {
                text = "You are out of the range of"
            }
            Notifications.display(text)
            
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
            
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
            
    }
    
    func applicationWillTerminate(application: UIApplication) {
            
    }
}
class Notifications {
        
        class func display(text: String){
            
            let notification: UILocalNotification = UILocalNotification()
            notification.timeZone = NSTimeZone.defaultTimeZone()
            
            let dateTime = NSDate()
            notification.fireDate = dateTime
            notification.alertBody = text
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        
}
