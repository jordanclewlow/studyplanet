//
//  ProgressBar.swift
//  studyplanet
//
//  Created by Jordan on 20/03/2021.
//

import UIKit

class ProgressBar: UIView {

    // change values from storyboard
    @IBInspectable public var backgroundCircleColour: UIColor = UIColor.clear
    @IBInspectable public var startGradientColour: UIColor = UIColor.red
    @IBInspectable public var endGradientColour: UIColor = UIColor.orange
    @IBInspectable public var textColour: UIColor = UIColor.white

    // declare shape properties
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var gradientLayer: CAGradientLayer!

    public var progress: CGFloat=0{
        didSet {
            didProgressUpdated()
        }
    }
    
    // draw the shape
    override func draw(_ rect: CGRect){
        // draw circle
        guard layer.sublayers == nil else {
            return
        }
        
        let width = rect.width
        let height = rect.height
        
        let lineWidth = 0.1 * min(width, height)
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.clear.cgColor, fillColor: backgroundCircleColour.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.red.cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
       
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint=CGPoint(x:0.5,y:0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y:1)
        gradientLayer.colors = [startGradientColour.cgColor, endGradientColour.cgColor]
        gradientLayer.frame = rect
        gradientLayer.mask = foregroundLayer
            
        // text inside circle
        textLayer = createTextLayer(rect: rect, textColor: textColour.cgColor)

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(textLayer)
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor:CGColor, fillColor: CGColor, lineWidth:CGFloat) -> CAShapeLayer{
        let width = rect.width
        let height = rect.height
    
        let center = CGPoint(x: width/2, y: height/2)
        let radius = (min(width, height) - lineWidth)/2
        
        let startAngle = -CGFloat.pi/2
        let endAngle = startAngle + 2*CGFloat.pi
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        return shapeLayer
    }
    
    // create text inside the circle
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        let width = rect.width
        let height = rect.height
        let fontSize = min(width, height)/4
        let offset = min(width,height)*0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress*100))"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height-fontSize-offset)/2, width: width, height: fontSize+offset)
        layer.alignmentMode = .center
        
        return layer
    }
    
    // update the progress
    private func didProgressUpdated() {
        textLayer?.string = "\(Int(progress*100))" + "%"
        foregroundLayer?.strokeEnd = progress
    }

  
}
