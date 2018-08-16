//
//  TodayViewController.swift
//  Today Widget
//
//  Created by macos on 8/15/18.
//  Copyright © 2018 AnhHD. All rights reserved.
//

import UIKit
import NotificationCenter
//import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource {
    
//    var realm : Realm!
//    var category: Results<ItemModel> {
//        get {
//            return realm.objects(category.self)
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return category.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

//        let item = category[indexPath.row]
//
//        cell.textLabel?.text = item.name

        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
//
//        let fileURL = directory.appendingPathComponent(K_DB_NAME)
//        realm = try! Realm(fileURL: fileURL)
//
//        print("category.count \(category.count)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
