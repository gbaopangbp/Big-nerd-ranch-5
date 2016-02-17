//
//  DrawView.swift
//  TouchTracker
//
//  Created by cm on 16/2/17.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine: Line?
    var finishedLines = [Line]()
    
    func strokeLine(line:Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.blueColor().setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        if let line = currentLine {
            UIColor.redColor().setStroke()
            strokeLine(line)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.locationInView(self)
        currentLine = Line(begin:location, end: location)
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        let location = touch.locationInView(self)
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if var line = currentLine {
            let touch = touches.first!
            
            let location = touch.locationInView(self)
            line.end = location
            
            finishedLines.append(line)

        }
        
        currentLine = nil
        setNeedsDisplay()
    }
}