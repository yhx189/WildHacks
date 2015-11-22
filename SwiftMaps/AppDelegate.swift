import UIKit
import GoogleMaps
import Parse
import Bolts
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate{
    
    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    var inNorris :Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // See https://developers.google.com/maps/documentation/ios/start#obtaining_an_api_key
        GMSServices.provideAPIKey("AIzaSyDHcwyIq8uSWGsCmts9I_vzAlZMr_C6nBw")
        
        
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        // Northwestern beascons all share the UIUD of B9407F30-F5F8-466E-AFF9-25556B57FE6D.
        
        self.beaconManager.startMonitoringForRegion(CLBeaconRegion(
            proximityUUID: NSUUID(UUIDString : "CF1A5302-EEBB-5C4F-AA18-851A36494C3D")!,
            major : 538, minor : 38376, identifier : "monitored region"))
        
        
        
        
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
    
    
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        let notification = UILocalNotification()
        notification.alertBody =
            // "Stories avaiable for this yoursTruly location"?
        "You've reached a yoursTruly location!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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

