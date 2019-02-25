//
//  Category.swift
//  Todoey
//
//  Created by AbedSabatien on 2/17/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
