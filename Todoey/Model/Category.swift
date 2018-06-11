//
//  Category.swift
//  Todoey
//
//  Created by OLAJUWON on 5/27/18.
//  Copyright © 2018 JAY BLACK. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
    @objc dynamic var dateCreated = Date()
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
