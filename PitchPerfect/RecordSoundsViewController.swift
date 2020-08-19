//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Courtney Caldwell on 8/18/20.
//  Copyright © 2020 Caldwell.codes. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButtonOut: UIButton!
    @IBOutlet weak var stopButtonOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // disable stop button by default
        stopButtonOut.isEnabled = false
    }
    // function contains sequence of enabling/disabling record/stop buttons, and changing indicator text
    func toggleRecordStop(_ toggle: Bool){
        if toggle {
            recordingLabel.text = "Recording..."
            recordButtonOut.isEnabled = false
            stopButtonOut.isEnabled = true
        }
        else{
            recordingLabel.text = "Tap to Record"
            recordButtonOut.isEnabled = true
            stopButtonOut.isEnabled = false
        }
    }

    @IBAction func recordButton(_ sender: Any) {
        toggleRecordStop(true)
        /* setup of audio file for passing to playback on next scene*/
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButton(_ sender: Any) {
        
        toggleRecordStop(false)
        /* stop function for audio to prepare sending through segue*/
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    /* segue attempt: if fails, crashes with error*/
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

