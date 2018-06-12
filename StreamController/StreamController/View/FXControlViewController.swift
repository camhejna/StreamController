//
//  FXControlViewController.swift
//  StreamController
//
//  Created by Cameron Hejna on 8/5/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit

class FXControlViewController: UIViewController {

    //EQ Sliders
    @IBOutlet weak var band1: UISlider!
    @IBOutlet weak var band2: UISlider!
    @IBOutlet weak var band3: UISlider!

    //DistortionSliders
    @IBOutlet weak var decimation: UISlider!
    @IBOutlet weak var ratioSlider: UISlider!
    @IBOutlet weak var distMix: UISlider!
    @IBOutlet weak var compLevel: UISlider!
    
    //ReverbSliders
    @IBOutlet weak var dwrSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //************************************************
    @IBAction func bandSliderMoved(_ sender: Any) {
        
        let bands : NSMutableArray = [
            band1.value,
            band2.value,
            band3.value
        ]
        
        CAController.updateEQCurve(bands: bands)
    }
    
    @IBAction func distSliderMoved(_ sender: Any) {
        
        let params : NSMutableArray = [
            decimation.value,
            ratioSlider.value,
            compLevel.value,
            distMix.value
        ]
        
        CAController.updateDistortion(params: params)
    }
    
    @IBAction func revbSliderMoved(_ sender: Any) {
        let params : NSMutableArray = [
            dwrSlider.value
        ]
        
        CAController.updateReverb(params: params)
    }
    
    
    
}
