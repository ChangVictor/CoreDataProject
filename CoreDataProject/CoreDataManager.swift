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
	
	func fetchCompanies() -> [Company] {
		let context = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
		do {
			let companies = try context.fetch(fetchRequest)
			return companies
		} catch let fetchError {
			print("Failed to fetch companies: ", fetchError)
			return []
		}
	}
	
	func createEmployee(employeeName: String) -> (Employee?, Error?)  {
		let context = persistentContainer.viewContext
		
		let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
		
		employee.setValue(employeeName, forKey: "name")
		
		do {
			try context.save()
			return (employee, nil)
		} catch let error {
			print("Failed to create employee", error )
			return (nil, error)
		}
	}
	
}
