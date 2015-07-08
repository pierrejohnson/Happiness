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
    
    
    
  private func UpdateUI()
    {
        faceView.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        // interprets the view for the model and the model for the view
        return Double (happiness-50)/50
    }
  
}
