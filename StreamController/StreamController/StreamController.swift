//
//  StreamController.swift
//  StreamController
//
//  Created by Cameron Hejna on 7/5/18.
//  Copyright © 2018 Cameron Anthony Hejna. All rights reserved.
//

import UIKit
import AVFoundation


let sharedStreamController = StreamController()

class StreamController{
    
    //static let player = SPTAudioStreamingController(clientId: Constants.clientID)
    //let spotifyPlayer : SPTAudioStreamingController
    let SCAController : SPTCoreAudioController
    //connectOutputBus:ofNode:toInputBus:ofNode:inGraph:error:
    let SCEngine : AVAudioEngine
    
    //var eqNode : AUNode
    //var eqUnit : AudioUnit
    
    //let graph : AUGraph?
    
    init() {
        //self.spotifyPlayer = SPTAudioStreamingController(clientId: Constants.clientID)
        
        self.SCEngine = AVAudioEngine.init()
        
        self.SCAController = SPTCoreAudioController.init()
        

        print("tmp")
        
        //not sure this is being used?
        
    }

}



class SCSPTController : SPTCoreAudioController {
    
    var eqNode : AUNode = 0
    var eqUnit : AudioUnit?
    
    var compNode : AUNode = 0
    var compUnit : AudioUnit?
    
    var revbNode : AUNode = 0
    var revbUnit : AudioUnit?
    
    
    //(BOOL)connectOutputBus:(UInt32)sourceOutputBusNumber ofNode:(AUNode)sourceNode toInputBus:(UInt32)destinationInputBusNumber ofNode:(AUNode)destinationNode inGraph:(AUGraph)graph error:(NSError **)error;
    override func connectOutputBus(_ sourceOutputBusNumber: UInt32, ofNode sourceNode: AUNode, toInputBus destinationInputBusNumber: UInt32, ofNode destinationNode: AUNode, in graph: AUGraph!) throws {
        
        //init and attach our eq
        
        //setup Desctiption
        var eqDescription = AudioComponentDescription.init(componentType: kAudioUnitType_Effect, componentSubType: kAudioUnitSubType_ParametricEQ, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        var compressorDescription = AudioComponentDescription.init(componentType: kAudioUnitType_Effect, componentSubType: kAudioUnitSubType_DynamicsProcessor, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        var reverbDescription = AudioComponentDescription.init(componentType: kAudioUnitType_Effect, componentSubType: kAudioUnitSubType_Reverb2, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        
        
        
        //add to the au graph
        var status = AUGraphAddNode(graph, &eqDescription, &eqNode)
        if status != noErr {
            print("Error: could not add eq")
        }
        status = AUGraphAddNode(graph, &compressorDescription, &compNode)
        if status != noErr{
            print("Error: could not add distortion")
        }
        status = AUGraphAddNode(graph, &reverbDescription, &revbNode)
        if status != noErr {
            print("Error: could not add reverb")
        }
        
        // Get the EQ Audio Unit from the node so we can set bands directly later
        status = AUGraphNodeInfo(graph, eqNode, nil, &eqUnit)
        if status != noErr {
            print("Couldn't get EQ Unit")
        }
        status = AUGraphNodeInfo(graph, compNode, nil, &compUnit)
        if status != noErr{
            print("Couldn't get dynamics unit")
        }
        status = AUGraphNodeInfo(graph, revbNode, nil, &revbUnit)
        if status != noErr{
            print("Couldn't get reverb unit")
        }
        
        //Init the AUs
        status = AudioUnitInitialize(eqUnit!)
        if status != noErr {
            print("Couldn't init EQ!")
        }
        status = AudioUnitInitialize(compUnit!)
        if status != noErr{
                print("Couldn't init reverb")
        }
        status = AudioUnitInitialize(revbUnit!)
        if status != noErr{
            print("Couldn't init reverb")
        }
        
        
        //Set params?
        status = AudioUnitSetParameter(eqUnit!, kParametricEQParam_Gain, kAudioUnitScope_Global, 0, 0.0, 0)
        if status != noErr{
            print("Couldn't set EQ Parameters")
        }
        status = AudioUnitSetParameter(compUnit!, kDistortionParam_FinalMix, kAudioUnitScope_Global, 0, 0.0, 0)
        if status != noErr {
            print("Couldn't set distortion parameters")
        }
        status = AudioUnitSetParameter(revbUnit!, kReverb2Param_DryWetMix, kAudioUnitScope_Global, 0, 0.0, 0 )
        
        // Connect the output of the source node to the input of the EQ node
        status = AUGraphConnectNodeInput(graph, sourceNode, sourceOutputBusNumber, eqNode, 0)
        if status != noErr {
            print("Couldn't connect converter to eq")
        }
        
        // Connect the output of the EQ node to the dynamics node
        status = AUGraphConnectNodeInput(graph, eqNode, 0, compNode, 0)
        if status != noErr {
            print("couldb't connect eq to output")
        }
        
        //connect output of the dynamics node to the reveb node
        status = AUGraphConnectNodeInput(graph, compNode, 0, revbNode, 0)
        if status != noErr{
            print("Error connecting bus")
        }
        
        
        //the input of the destination node, thus completing the chain.
        status = AUGraphConnectNodeInput(graph, revbNode, 0, destinationNode, destinationInputBusNumber)
        if status != noErr{
            print("Error connecting bus")
        }
        
        
        print("connectedOutputBus(...) success")
    }
    
    override func disposeOfCustomNodes(in graph: AUGraph!) {
        AudioUnitUninitialize(eqUnit!)
        eqUnit = nil
        
        AUGraphRemoveNode(graph, eqNode)
        eqNode = 0
        
        AudioUnitUninitialize(compUnit!)
        AUGraphRemoveNode(graph, compNode)
        compNode = 0
        
        
    }
    
    func updateEQCurve(bands: NSMutableArray){
        //print("update EQCurve")
        
        if (eqUnit == nil) {return}
        
//        for i in 0...9 {
//            let bandValue : Float32 = bands[i] as! Float32
//            AudioUnitSetParameter(eqUnit!, AudioUnitParameterID(i), kAudioUnitScope_Global, 0, bandValue, 0)
//        }
        
        AudioUnitSetParameter(eqUnit!, kParametricEQParam_Gain, kAudioUnitScope_Global, 0, bands[0] as! AudioUnitParameterValue, 0)
        AudioUnitSetParameter(eqUnit!, kParametricEQParam_CenterFreq, kAudioUnitScope_Global, 0, bands[1] as! AudioUnitParameterValue, 0)
        AudioUnitSetParameter(eqUnit!, kParametricEQParam_Q, kAudioUnitScope_Global, 0, bands[2] as! AudioUnitParameterValue, 0)
        
        //debugLineAccess()
    }
    
    func updateDistortion(params: NSMutableArray){
        if compUnit == nil {return}
        
        AudioUnitSetParameter(compUnit!, kDynamicsProcessorParam_Threshold, kAudioUnitScope_Global, 0, params[0] as! AudioUnitParameterValue, 0)
        AudioUnitSetParameter(compUnit!, kDynamicsProcessorParam_ExpansionRatio, kAudioUnitScope_Global, 0, params[1] as! AudioUnitParameterValue, 0)
        AudioUnitSetParameter(compUnit!, kDynamicsProcessorParam_CompressionAmount, kAudioUnitScope_Global, 0, params[2] as! AudioUnitParameterValue, 0)
        AudioUnitSetParameter(compUnit!, kDynamicsProcessorParam_MasterGain, kAudioUnitScope_Global, 0, params[3] as! AudioUnitParameterValue, 0)
        
    }
    
    func updateReverb(params: NSMutableArray){
        if revbUnit == nil {return}
        
        AudioUnitSetParameter(revbUnit!, kReverb2Param_DryWetMix, kAudioUnitScope_Global, 0, params[0] as! AudioUnitParameterValue, 0)
        
    }
    
    func debugLineAccess(){
        print("nothing")
    }
    
}
