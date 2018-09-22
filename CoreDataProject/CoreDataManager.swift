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
	
	func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?)  {
		let context = persistentContainer.viewContext
		//create an employee
		let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
		
		employee.company = company
		employee.type = employeeType
		
		//check company is set up correctly
//		let company = Company(context: context)

		employee.setValue(employeeName, forKey: "name")
		
		let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
		employeeInformation.taxId = "456"
		employeeInformation.birthday = birthday
//		employeeInformation.setValue("456", forKey: "taxId")
		employee.employeeInformation = employeeInformation
		
		do {
			try context.save()
			return (employee, nil)
		} catch let error {
			print("Failed to create employee", error )
			return (nil, error)
		}
	}
	
}
