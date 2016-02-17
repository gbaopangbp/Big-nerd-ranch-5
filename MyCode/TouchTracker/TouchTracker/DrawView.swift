//
//  DrawView.swift
//  TouchTracker
//
//  Created by cm on 16/2/17.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine = [NSValue:Line]()
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
        for line in currentLine.values {
            UIColor.redColor().setStroke()
            strokeLine(line)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self)
            let line = Line(begin:location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLine[key] = line
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self)
            let key = NSValue(nonretainedObject: touch)
            currentLine[key]?.end = location
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLine[key] {
                let location = touch.locationInView(self)
                line.end = location
                
                finishedLines.append(line)
                currentLine.removeValueForKey(key)
                
            }
        }
   
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentLine.removeAll()
        setNeedsDisplay()
    }
}
