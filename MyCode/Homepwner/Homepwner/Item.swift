//
//  Item.swift
//  Homepwner
//
//  Created by cm on 16/2/15.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class Item: NSObject,NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: NSDate
    var imageKey: String
    
    required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObjectForKey("name") as! String
        serialNumber = aDecoder.decodeObjectForKey("serialNumber") as! String
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        imageKey = aDecoder.decodeObjectForKey("imageKey") as! String
        valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
        super.init()


    }
    
    init(name: String, serialNumber:String?, valueInDollars: Int) {
        self.name = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreated = NSDate()
        self.imageKey = NSUUID().UUIDString
        
        super.init()
        
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().UUIDString.componentsSeparatedByString("-").first
            
            self.init(name:randomName, serialNumber:randomSerialNumber, valueInDollars:randomValue)
        } else {
            self.init(name:"", serialNumber:nil, valueInDollars:0)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(serialNumber, forKey: "serialNumber")
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        aCoder.encodeObject(imageKey, forKey: "imageKey")
        aCoder.encodeInteger(valueInDollars, forKey: "valueInDollars")

    }
}
