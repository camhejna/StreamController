//
//  LibraryTableViewController.swift
//  StreamController
//
//  Created by Cameron Anthony Hejna on 29/4/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit

class LibraryTableViewController : UITableViewController {
    
    
    //TODO: Remove?
    var yourMusicLib : SPTYourMusic?
    var trackURIs : [SPTSavedTrack] = []
    var tableData : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //self.tableView.delegate = self
        
        
        
        setupLibrary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    let cellId = "cellId1"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell")
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        print("user interaction enabled? \(String(describing: cell?.isUserInteractionEnabled))")

        // Configure the cell...
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        let trackURI = self.trackURIs[indexPath.row].name
        
        cell?.textLabel?.text = trackURI
        
        return cell!
    }
 
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
//        print("did select row at")
//        //SPTAudioStreamingController.sharedInstance().playSpotifyURI(trackURIs[indexPath.row]. as! String, startingWith: 0, startingWithPosition: 0, callback: nil)
//        let stringURI = trackURIs[indexPath.row].playableUri
//        //SPTAudioStreamingController.sharedInstance().playSpotifyURI(
//    }

    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //your code...
        print("cell selected...")
        let stringURI = trackURIs[indexPath.row].playableUri.absoluteString
        print(stringURI)
        
        SPTAudioStreamingController.sharedInstance().playSpotifyURI(stringURI, startingWith: 0, startingWithPosition: 0, callback: nil)
        
        self.tabBarController?.selectedIndex = 1
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //******************************************************************************************************
    func setupLibrary(){
        print("setupLibrary")
        
        //TODO: Remove?
        yourMusicLib = SPTYourMusic.init()
        
        
        
        //***************TODO: Delete?
//        do {
//             let libraryRequest = try SPTYourMusic.createRequestForCurrentUsersSavedTracks(withAccessToken: Constants.accessToken)
//
//
//            //let libRequestHandler = SPTRequest.performRequest(libraryRequest)
//
//
//
//
//
//
//
//        } catch {
//            print(error)
//        }
        //*********************
        
        
        
        SPTYourMusic.savedTracksForUser(withAccessToken: Constants.accessToken, callback: {error,session in
            if let error = error {
                print(error)
                return
            }
            
            if let session = session{
                
                
                //TODO:
                print("Got the tracks!")
                self.trackURIs = (session as! SPTListPage).items as! [SPTSavedTrack]
                print("nothin")
                

                    for i in 0..<self.trackURIs.count {
                        self.tableData.append("null")
                        let selectionIndex = 0
                        let iPath : IndexPath = IndexPath(row: i, section: selectionIndex)
                        self.tableView.insertRows(at: [iPath], with: UITableViewRowAnimation.left)
                    }
                
                
                
            }
            
        })
        
        
        
        
        
        
        
        
    }
    
    

    
    
    

}
