//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Dany Cabrera Vargas on 24/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

	@IBOutlet weak var lblRecording: UILabel!
	@IBOutlet weak var btnRecord: UIButton!
	@IBOutlet weak var btnStop: UIButton!
	@IBOutlet weak var btnPause: UIButton!

	var audioRecorder: AVAudioRecorder!
	var recordedAudio: RecordedAudio!
	var recording: Bool!
	var imgPause: UIImage!

	override func viewDidLoad() {
		super.viewDidLoad()
		imgPause = UIImage(named: "btPause") as UIImage!
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func viewWillAppear(animated: Bool) {
		lblRecording.text = "Tap to record"
		btnStop.hidden = true
		btnPause.hidden = true
		recording = false
	}

	// Delegate function for when the recording is finished
	// Performs segue after the recording stops
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
		if (flag) {
			recordedAudio = RecordedAudio(url: recorder.url)
			self.performSegueWithIdentifier("stopRecordSegue", sender: recordedAudio)
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "stopRecordSegue") {
			// Pass audio file information to next VC
			let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
			let data = sender as! RecordedAudio
			playSoundsVC.receivedAudio = data
		}
	}

	//  Record button -> Resume or pause recording
	@IBAction func recordAudio(sender: UIButton) {
		// Should we start recording? or resume?
		if (!recording) {
			recording = true
			lblRecording.text = "Recording..."
			btnStop.hidden = false
			btnPause.hidden = false
			btnRecord.hidden = true

			// Get a valid filepath for storing the audio
			let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
			let recordingName = "my_recording.wav"
			let pathArray = [dirPath, recordingName]
			let filePath = NSURL.fileURLWithPathComponents(pathArray)

			// Start recording
			var session = AVAudioSession.sharedInstance()
			session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
			audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
			audioRecorder.delegate = self
			audioRecorder.meteringEnabled = true
			audioRecorder.prepareToRecord()
			audioRecorder.record()
		}
		else {
			// Resume recording
			audioRecorder.record()
			lblRecording.text = "Recording..."
			btnPause.hidden = false
			btnRecord.hidden = true
		}

	}

	// Stop button -> Stop recording
	@IBAction func stop(sender: UIButton) {
		audioRecorder.stop() // takes some time to stop and save the audio
		var audioSession = AVAudioSession.sharedInstance()
		audioSession.setActive(false, error: nil)
	}

	// Pause button -> Pause recording
	@IBAction func pause(sender: UIButton) {
		audioRecorder.pause()
		btnPause.hidden = true
		btnRecord.hidden = false
		lblRecording.text = "Tap to resume recording"
	}
}
