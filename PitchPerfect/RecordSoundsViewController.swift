//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Courtney Caldwell on 8/18/20.
//  Copyright © 2020 Caldwell.codes. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButtonOut: UIButton!
    @IBOutlet weak var stopButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopButtonOut.isEnabled = false
    }

    @IBAction func recordButton(_ sender: Any) {
        print("Record button was pressed")
        recordingLabel.text = "Recording..."
        recordButtonOut.isEnabled = false
        stopButtonOut.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        print("Stop button was pressed")
        recordingLabel.text = "Tap to Record"
        stopButtonOut.isEnabled = false
        recordButtonOut.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

