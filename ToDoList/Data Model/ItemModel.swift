//
//  ItemModel.swift
//  ToDoList
//
//  Created by macos on 8/8/18.
//  Copyright © 2018 AnhHD. All rights reserved.
//

import Foundation
import RealmSwift

class ItemModel: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: CategoryModel.self, property: "items")
}
