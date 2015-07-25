//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Dany Cabrera Vargas on 24/07/15.
//  Copyright (c) 2015 Dany Alejandro Cabrera Vargas. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
	var audioFile: AVAudioFile!
	var audioEngine: AVAudioEngine!
	var receivedAudio: RecordedAudio!


	override func viewDidLoad() {
		super.viewDidLoad()

		audioEngine = AVAudioEngine()
		audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


	// Play audio with specified pitch and rate
	func playAudio(#pitch: Float, rate: Float, echo: NSTimeInterval){
		audioEngine.stop()

		// configure and connect nodes
		var audioPlayerNode = AVAudioPlayerNode()
		var changePitchEffect = AVAudioUnitTimePitch()
		var echoEffect = AVAudioUnitDelay()
		changePitchEffect.pitch = pitch
		changePitchEffect.rate = rate

		audioEngine.attachNode(audioPlayerNode)
		audioEngine.attachNode(changePitchEffect)
		audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)

		if (echo > 0) {
			// if echo is required, configure and connect echo node
			echoEffect.delayTime = echo
			echoEffect.feedback = 0.3
			audioEngine.attachNode(echoEffect)
			audioEngine.connect(changePitchEffect, to: echoEffect, format: nil)
			audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
		}
		else {
			audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
		}

		// play audio file
		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
		audioEngine.startAndReturnError(nil)
		audioPlayerNode.play()
	}


	// Stop button -> Stop and reset audio
	@IBAction func stop(sender: UIButton) {
		audioEngine.stop()
		audioEngine.reset()
	}

	// Bunny button -> Play fast
	@IBAction func playFast(sender: UIButton) {
		playAudio(pitch: 1.0, rate: 2.0, echo: 0)
	}

	// Chipmunk button -> Play high pitch
	@IBAction func playChipmunk(sender: UIButton) {
		playAudio(pitch: 1100, rate: 1.0, echo: 0)
	}

	// Darth Vader button -> Play low pitch
	@IBAction func playDarth(sender: UIButton) {
		playAudio(pitch: -800, rate: 1.0, echo: 0)
	}

	// Turtle button -> Play slow
	@IBAction func playSlow(sender: UIButton) {
		playAudio(pitch: 1.0, rate: 0.6, echo: 0)
	}

	// Bunnies button -> Play with echo
	@IBAction func playEcho(sender: UIButton) {
		playAudio(pitch: 1.0, rate: 1.0, echo: 0.1)
	}

}
