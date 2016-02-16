//
//  ItemStore.swift
//  Homepwner
//
//  Created by cm on 16/2/15.
//  Copyright © 2016年 cm. All rights reserved.
//

import Foundation

class ItemStore{
    var allItems:[Item] = [Item]()
    let saveUrl:NSURL = {
        let docPaths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (docPaths.first?.URLByAppendingPathComponent("items.archer"))!
    }()
    
    init(){
        if let saveItems = NSKeyedUnarchiver.unarchiveObjectWithFile(saveUrl.path!) as? [Item] {
            allItems += saveItems
        }
        

    }
    
    func createItem()->Item {
        let item = Item(random: true)
        allItems.append(item)
        return item
    }
    
    func removeItem(item:Item){
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItem(from:Int, toIndex:Int) {
        if from == toIndex {
            return
        }
        
        let moveItem = allItems[from]
        allItems.removeAtIndex(from)
        
        allItems.insert(moveItem, atIndex: toIndex)
    
    }
    
    func saveChanges() ->Bool{
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: saveUrl.path!)
    }
}
