import UIKit
import GoogleMaps
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate{

  var window: UIWindow?
  let beaconManager = ESTBeaconManager()
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // See https://developers.google.com/maps/documentation/ios/start#obtaining_an_api_key
    GMSServices.provideAPIKey("AIzaSyDHcwyIq8uSWGsCmts9I_vzAlZMr_C6nBw")
    
    
    
    self.beaconManager.delegate = self
    self.beaconManager.requestAlwaysAuthorization()
    
    
    
    Parse.enableLocalDatastore()
    
    // Initialize Parse.
    Parse.setApplicationId("rh45K7o7xlkEsxTyKRbw7az2jeFNdTqvunowGrFc",
        clientKey: "R8lw2NeO6cx9d021hpJGLLfXV6pBVYCygW6TSCBh")
    return true
  }

}

