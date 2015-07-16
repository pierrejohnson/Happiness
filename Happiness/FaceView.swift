//
//  FaceView.swift
//  Happiness
//
//  Created by AmenophisIII on 7/7/15.
//  Copyright (c) 2015 AmenophisIII. All rights reserved.
//

import UIKit

// how the view uses the controller to update it. Note no implementation, just declaration
protocol FaceViewDataSource : class {
    // the only purpose is to get the data - so we call it DataSource
    func smilinessForFaceView (sender: FaceView) -> Double?
    // func will pass the view itself - so we have a reference
}

@IBDesignable // so we view it in storyboard
class FaceView: UIView
{

    
    
    
    
    
    
    
    @IBInspectable
    var lineWidth  : CGFloat = 3                    { didSet { setNeedsDisplay() }} // notice the observer, calling a redraw if var changes
    @IBInspectable
    var color      : UIColor = UIColor.blueColor()  { didSet { setNeedsDisplay() }}
    @IBInspectable
    var scale      : CGFloat = 0.9                  { didSet { setNeedsDisplay() }}
    var faceCenter : CGPoint                        { return convertPoint(center, fromView: superview) }
    var faceRadius : CGFloat                        { return min (bounds.size.width, bounds.size.height) / 2 * scale }
    // this is how you create constants in Swift - create a struct and declare within
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio     : CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio     : CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio : CGFloat = 1.5
        static let FaceRadiusToMouthwidthRatio    : CGFloat = 1
        static let FaceRadiusToMouthHeightRatio   : CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio   : CGFloat = 3
    }
    
    private enum Eye { case Left, Right }

    // Draws eyes at the right locations
    private func bezierPathForEye ( whichEye: Eye ) -> UIBezierPath
    {
    
        let eyeRadius               = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio // the calculations are necessary to make sure the scaling adapts to different screen sizes
        let eyeVerticalOffset       = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
    
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset  // curious as to what exatly is going on here
        switch whichEye {
            case  .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
            case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
    
        let path = UIBezierPath (arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }

    
    
    // Draws a smile on the screen
    private func bezierPathForSmile ( fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth          = faceRadius / Scaling.FaceRadiusToMouthwidthRatio
        let mouthHeight         = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let smileHeight         = CGFloat ( max ( min (fractionOfMaxSmile,1), -1 ) ) * mouthHeight
        let start               = CGPoint (x: faceCenter.x - mouthWidth / 2 , y: faceCenter.y + mouthVerticalOffset)
        let end                 = CGPoint (x: start.x + mouthWidth, y: start.y)
        let cp1                 = CGPoint (x: start.x + mouthWidth / 3,  y:start.y  + smileHeight)
        let cp2                 = CGPoint (x:end.x - mouthWidth / 3, y:cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    
        
    }
    // we need to use "weak" to make sure that the datasource pointer will not be used to keep it in memory (so the REF to itself in the controller implementation does not force it in memory)
    weak var dataSource : FaceViewDataSource? // PROTOCOL
    
    
    // our "Pinch handler"
    func scale (gesture: UIPinchGestureRecognizer){
        if gesture.state == .Changed{
            scale *= gesture.scale
            gesture.scale = 1
        }
        
    }
    
    
    
    // we override the drawRect func to be able to draw
    override func drawRect(rect: CGRect)
    {
        let facePath = UIBezierPath (arcCenter: faceCenter, radius: faceRadius, startAngle: 0 , endAngle: CGFloat(2*M_PI), clockwise: true)
        
        facePath.lineWidth = lineWidth  // we set the default linewidth
        color.set()                     // we set the color
        facePath.stroke()               // we DRAW / stroke the face
        
        
        bezierPathForEye(.Left).stroke() // we DRAW / stroke the eye
        bezierPathForEye(.Right).stroke()// we DRAW / stroke the eye

        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke() // we DRAW / stroke the smile
        
    }

}
