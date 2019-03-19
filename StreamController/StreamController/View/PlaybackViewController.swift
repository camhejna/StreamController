//
//  PlaybackViewController.swift
//  StreamController
//
//  Created by Cameron Anthony Hejna on 29/4/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //testPlaySpotify()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hidden button func to test spotify player is working correctly
    func testPlaySpotify(){
        print("testPlaySpotify()")
        SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:track:74z2lfZ7fj3IqoK71lHkZw", startingWith: 0, startingWithPosition: 0, callback: nil)
    }

    @IBAction func musicTestButtonPressed(_ sender: Any) {
        
        testPlaySpotify()
        
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        
        SPTAudioStreamingController.sharedInstance()?.setIsPlaying(!SPTAudioStreamingController.sharedInstance().playbackState.isPlaying, callback: nil)

    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        updateUI()
    }
    
    func updateUI(){
        trackLabel.text = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.name
        albumLabel.text = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.albumName
        artistLabel.text = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.artistName
        
        let imageURL = SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.albumCoverArtURL
        let image = UIImage(data: try! Data(contentsOf: URL(string: imageURL!)!))
        albumArtwork.image = image
    }
}
