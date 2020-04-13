//
//  ViewController.swift
//  NoahStifflerGestures
//
//  Created by Noah Stiffler on 4/8/20.
//  Copyright © 2020 Noah Stiffler. All rights reserved.
//

import UIKit
import AudioToolbox
import MediaPlayer
import CoreMotion

class ViewController: UIViewController {

  //  var motionManager: CMMotionManager!

    var crayons = 0
    var drop = 0
  
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var dropLabel: UILabel!
    
    @IBOutlet weak var brokenScreen: UIImageView!
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    
    // The idea behind this shake function is that once the user started eating crayons, the volume of the eating sound would be loud and scare them. When they would jolt their phone it would mute.
    //I almost wish this was a default feature of my phone for when I accidentally play something loud when I dont mean to.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // I got the volume control code from StackOverflow
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0, animated: false)
        }

    }
    
    let motion = CMMotionManager()
    
    var timer: Timer?
    
  //I got this method from Apple Developer documentation "Getting Raw Accelerometer Events"
    func startAccelerometer() {
        
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 10.0
            self.motion.startAccelerometerUpdates()
            
            self.timer = Timer(fire: Date(), interval: (1.0/10.0), repeats: true, block: { (timer) in
                
                if let data = self.motion.accelerometerData {
                  //  let x = data.acceleration.x
                  //  let y = data.acceleration.y
                    let z = data.acceleration.z
                    
                    
                    // This will test if the phones Z value for the accelerometer (which would be the vertical measurment) has a G force of greater than .9.
                    // When the phone is in free fall it actually has 0 g, but the accelerometer will read a free fall at 1g (beacuse you are accelerating at 1g / 9.8m/s/s)
                    if z > 1 {
                        //The idea is that this would only happen once (and then the phone would be broken) which is why there is no counter.
                        self.dropLabel.text = "1"
                        self.brokenScreen.isHidden = false
                        // Also dropping the phone shows a .png image of shattered glass over the phone, just to scare the user
                        
                    }
                }
            })
            RunLoop.current.add(self.timer!, forMode: .default)
            
        }
    }
    
    
   
    
  
    
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
        var soundID: SystemSoundID = 0
        let soundFile:String=Bundle.main.path(forResource:"eating",ofType: "mp3")!
        let soundURL:NSURL = NSURL(fileURLWithPath: soundFile)
        AudioServicesCreateSystemSoundID(soundURL,&soundID)
        AudioServicesPlaySystemSound(soundID)
        
        countLabel.text = String(crayons + 10)
        crayons += 10
        
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Set volume to max on run
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
        
        // motionManager = CMMotionManager()
        // motionManager.startAccelerometerUpdates()
        
        startAccelerometer()
        
        
    }


}
