//
//  ItemStore.swift
//  Homepwner
//
//  Created by cm on 16/2/15.
//  Copyright © 2016年 cm. All rights reserved.
//

import Foundation

class ItemStore{
    var allItems:[Item]
    
    init(){
        allItems = [Item]()
        
        
        for _ in 0..<5 {
            self.createItem()
        }
    }
    
    func createItem()->Item {
        let item = Item(random: true)
        allItems.append(item)
        return item
    }
}
