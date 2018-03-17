//
//  Category.swift
//  Ziel Todo
//
//  Created by gunm on 15/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
