//
//  CategoryModel.swift
//  ToDoList
//
//  Created by macos on 8/8/18.
//  Copyright © 2018 AnhHD. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object {
//    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var colorHexCode: String = ""
    let items = List<ItemModel>()
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
