//
//  AppDelegate.swift
//  Ziel Todo
//
//  Created by gunm on 12/03/18.
//  Copyright © 2018 Gunaseelan. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
       
       
        do{
            
             _ = try Realm()
            
        }catch{
            
            print("Error while initilaise realm \(error)")
            
        }
        
        
        return true
    }
}

