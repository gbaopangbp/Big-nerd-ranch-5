//
//  DrawView.swift
//  TouchTracker
//
//  Created by cm on 16/2/17.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class DrawView: UIView,UIGestureRecognizerDelegate {
    var currentLine = [NSValue:Line]()
    var finishedLines = [Line]()
    var selectLineIndex:Int? {
        didSet{
            if selectLineIndex == nil {
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var move:UIPanGestureRecognizer!
    
    @IBInspectable var finishLineCorlor: UIColor = UIColor.blackColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineCorlor: UIColor = UIColor.redColor() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var linewidth: CGFloat = 10 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    func indexOfSelectLine(point:CGPoint)->Int? {
        for (index,line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + (end.x - begin.x)*t
                let y = begin.y + (end.y - begin.y)*t
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTap.delaysTouchesBegan = true
        doubleTap.numberOfTouchesRequired = 2
        addGestureRecognizer(doubleTap)
    
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        tap.requireGestureRecognizerToFail(doubleTap)
        addGestureRecognizer(tap)
        
        let long = UILongPressGestureRecognizer(target: self, action: "long:")
        addGestureRecognizer(long)
        
        move = UIPanGestureRecognizer(target: self, action: "move:")
        move.cancelsTouchesInView = false
        move.delegate = self
        addGestureRecognizer(move)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }

    
    func move(gesture:UIPanGestureRecognizer) {
        if let index = selectLineIndex {
            if gesture.state == .Changed {
                let move = gesture.translationInView(self)
                
                finishedLines[index].begin.x += move.x
                finishedLines[index].begin.y += move.y
                finishedLines[index].end.x += move.x
                finishedLines[index].end.y += move.y
                setNeedsDisplay()
            }
        }
    }

    
    
    func long(gesture:UIGestureRecognizer) {
        if gesture.state == .Began {
            let point = gesture.locationInView(self)
            selectLineIndex = indexOfSelectLine(point)
            if selectLineIndex != nil {
                currentLine.removeAll()
            }
        } else if gesture.state == .Ended {
            selectLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    func doubleTap(gesture:UIGestureRecognizer) {
        selectLineIndex = nil
        currentLine.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    func tap(gesture:UIGestureRecognizer) {
        let point = gesture.locationInView(self)
        selectLineIndex = indexOfSelectLine(point)
        
        let menu = UIMenuController.sharedMenuController()
        if selectLineIndex != nil {
            becomeFirstResponder()
            
            let action = UIMenuItem(title: "deletee:", action: "deletee:")
            menu.menuItems = [action]
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 20, height: 20), inView: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    func deletee(sender:AnyObject) {
        if let liine = selectLineIndex {
            finishedLines.removeAtIndex(liine)
            selectLineIndex = nil
            setNeedsDisplay()
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    func strokeLine(line:Line) {
        let path = UIBezierPath()
        path.lineWidth = linewidth
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        finishLineCorlor.setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        for line in currentLine.values {
            currentLineCorlor.setStroke()
            strokeLine(line)
        }
        
        if let index = selectLineIndex {
            UIColor.greenColor().setStroke()
            let line = finishedLines[index]
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
