//
//  HappinessViewController.swift
//  Happiness
//
//  Created by AmenophisIII on 7/7/15.
//  Copyright (c) 2015 AmenophisIII. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource
{

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:")) // setting up gesture in code - other way is in the storyboard
        }
        
    }
    
    
    //the MODEL
    var happiness : Int = 99 { // 0 is sad, 100 is ecstatic
        didSet {
            happiness = min(max(0, happiness), 100)
            println("Happiness = \(happiness) ")
            UpdateUI()
        }
    
    }
    
    private struct Constants {
        static let happinessGestureScale :CGFloat = 4
    }
    
    
    // this is @IBAction because it was created via StoryBoard
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = Int(translation.y / Constants.happinessGestureScale)
            if happinessChange != 0 {
            happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:
            break
        }
    }
    
    
  private func UpdateUI()
    {
        faceView.setNeedsDisplay()
    }
    
    // we implement the protocol function.... which will trigger a redrwa from within the controller
    func smilinessForFaceView(sender: FaceView) -> Double? {
        // interprets the view for the model and the model for the view
        return Double (happiness-50)/50
    }
  
}
