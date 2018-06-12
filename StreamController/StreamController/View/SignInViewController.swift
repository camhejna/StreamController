//
//  ViewController.swift
//  StreamController
//
//  Created by Cameron Anthony Hejna on 29/4/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {
    
    var spotifyAuthWebView : SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        let appURL = SPTAuth.defaultInstance().spotifyAppAuthenticationURL()!
        let webURL = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()!
        
        
        // attach notification listener
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receievedUrlFromSpotify(_:)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        
        
        //Check to see if the user has Spotify installed
        if SPTAuth.supportsApplicationAuthentication() {
            //Open the Spotify app by opening its url
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            //Present a web browser in the app that lets the user sign in to Spotify
            spotifyAuthWebView = SFSafariViewController(url: webURL)
            present(spotifyAuthWebView!, animated: true, completion: nil)
        }
        
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        print("receivedUrlFromSpotify")
        
        guard let url = notification.object as? URL else { return }
        
        // Close the web view if it exists
        spotifyAuthWebView?.dismiss(animated: true, completion: nil)
        
        
        // Remove the observer from the Notification Center
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.Spotify.authURLOpened,
                                                  object: nil)
        
        SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
            if let error = error {
                self.displayErrorMessage(error: error)
                return
            }
            
            if let session = session {
                Constants.accessToken = session.accessToken
                            
                SPTAudioStreamingController.sharedInstance().delegate = self
                SPTAudioStreamingController.sharedInstance().login(withAccessToken: session.accessToken)
            }
        }
        
    }
    
    func displayErrorMessage(error: Error) {
        
         DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        
        DispatchQueue.main.async {
            //setup everything
            
            
            
            
            
            
            
            
            
            // go to main Tab Bar
            //self.present(PlaybackViewController(), animated: true, completion: nil)
            //let controller = PlaybackViewController()
            //self.present(controller, animated: true, completion: nil)
            self.performSegue(withIdentifier: "segueToPlayer", sender: self)
        }
    }
    


}


extension SignInViewController: SPTAudioStreamingDelegate {
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.successfulLogin()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        displayErrorMessage(error: error)
    }
}

