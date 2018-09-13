//
//  CoreDataManager.swift
//  CoreDataProject
//
//  Created by Victor Chang on 13/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
	
	static let shared = CoreDataManager()
	
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "DataModel")
		
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				fatalError("Loading of store failed: \(error)")
			}
		}
		return container
	}()
	
}
