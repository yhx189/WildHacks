import UIKit
import GoogleMaps
import Parse
import AVFoundation



class SecondViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, ESTBeaconManagerDelegate {
    let beaconManager = ESTBeaconManager()
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    var imagePlay:UIImage!
    var timer = NSTimer()
    var counter = 0
    @IBOutlet var recordButton: UIButton!
    
    
    @IBOutlet var countingLabel: UILabel!
    
    func updateCounter() {
        countingLabel.text = String(counter++)
    }
    
    
    @IBAction func recordAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            
            audioRecorder?.record()
            print ("starting recording...")
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
            
            
        } else{
            
            
            audioRecorder?.stop()
            
            
            
            let alert = UIAlertController(title: "Alert", message: "You're finished your message, confirm drop?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction!) -> Void in
                
                let dataToUpload : NSData = NSData(contentsOfURL: (self.audioRecorder?.url)!)!
                let soundFile = PFFile(name: "audio.wav", data: dataToUpload)
                let buyers = PFObject(className: "Buyers")
                buyers["Name"] = "Norris"
                buyers["records"] = soundFile
                buyers.saveInBackground()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            timer.invalidate()
            counter = 0
            countingLabel.text = String(counter)
            
            print ("stop recording...")
            
        }
        
        
    }
    func uploadParse(){
        let dataToUpload : NSData = NSData(contentsOfURL: (audioRecorder?.url)!)!
        
        let soundFile = PFFile(name: "audio", data: dataToUpload)
        
        let buyers = PFObject(className: "Buyers")
        buyers["records"] = soundFile
        buyers.saveInBackground()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        recordButton = UIButton(type: .Custom)
        imagePlay = UIImage(named:"play.jpg")
        recordButton.setImage(imagePlay, forState: .Normal)
        
        let soundFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("sound.wav")
        //let docsDir = dirPaths[0]  //as! String
        //let soundFilePath =
        //  docsDir.URLByAppendingPathComponent("sound.caf")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath.path!)
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord) //,    error: &error)
        } catch{
            
            print("audioSession error: ")
            
        }
        do{
            try audioRecorder = AVAudioRecorder(URL: soundFileURL,
                settings: recordSettings as! [String : AnyObject]  )
            
        } catch{
            
            print  ("audioSession error: ")
            
        }
        audioRecorder?.prepareToRecord()
        
        
    }
    /*
    override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    */
}
