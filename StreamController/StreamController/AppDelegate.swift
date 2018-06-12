//
//  AppDelegate.swift
//  StreamController
//
//  Created by Cameron Anthony Hejna on 29/4/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit

let CAController = SCSPTController.init()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    //var streamController: SCSPTController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSpotify()
        
        
        return true
    }
    
    //This function is called when the app is opened by a URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //Check if this URL was sent from the Spotify app or website
        if SPTAuth.defaultInstance().canHandle(url) {
            print("URL callback success")
            audioStreamingDidLogin(SPTAudioStreamingController.sharedInstance())
            
            //Send out a notification to listen for in  SignInViewController
            NotificationCenter.default.post(name: NSNotification.Name.Spotify.authURLOpened, object: url)
            
            
            
            return true
        } else {
            print("cannot open url\n")
        }
        
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        SPTAuth.defaultInstance().session = nil
    }
    
    //***********************************SETUP SPOTIFY
    func setupSpotify() {
        print("setupSpotify()")
        SPTAuth.defaultInstance().clientID = Constants.clientID
        SPTAuth.defaultInstance().redirectURL = Constants.redirectURI
        SPTAuth.defaultInstance().sessionUserDefaultsKey = Constants.sessionKey
        
        //SPTAuth.defaultInstance().tokenSwapURL
        
        //For this application we just want to stream music, so we will only request the streaming scope
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthUserLibraryReadScope, SPTAuthPlaylistReadPrivateScope]
        
        //TODO:
        //SPTAuthPlaylistReadPrivateScope
        //SPTAuthUserLibraryReadScope
        
        // Start the player
        do {
            
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Constants.clientID, audioController: CAController, allowCaching: true)
            print("added CAController to SPAudioStreamingController.sharedInstance()")
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
    
    func audioStreamingDidLogin(_ controller: SPTAudioStreamingController){
        print("audioStreamingDidLogin")
        
        
        
    }


}

extension Notification.Name {
    struct Spotify {
        static let authURLOpened = Notification.Name("authURLOpened")
    }
}

