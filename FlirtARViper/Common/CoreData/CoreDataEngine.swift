//
//  CoreDataEngine.swift
//  FlirtARViper
//
//  Created by   on 24.08.17.
//  Copyright © 2017  . All rights reserved.
//

import UIKit
import CoreData

class CoreDataEngine {
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentStoreCoordinator
        }
        return nil
    }
    
    static var managedObjectModel: NSManagedObjectModel? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.managedObjectModel
        }
        return nil
    }
    
    static var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.managedObjectContext
        }
        return nil
    }
    
    
}

