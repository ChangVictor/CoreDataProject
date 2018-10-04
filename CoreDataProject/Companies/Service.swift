//
//  Service.swift
//  CoreDataProject
//
//  Created by Victor Chang on 03/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation
import CoreData

struct Service {
	
	static let shared = Service()
	
	let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
	
	func downloadCompaniesFromServer() {
		print("Attempring to download companies")
		
		guard let url =  URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url ) { (data, response, error) in
			
			print("finish downloading")
			
			if let error = error {
				print("Failed to download company", error)
			}
			
			guard let data = data else { return }
//			let string = String(data: data, encoding: .utf8)
			let jsonDecoder = JSONDecoder()
			do {
				
				let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
				
				let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
				privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
				
				jsonCompanies.forEach({ (jsonCompany) in
					print(jsonCompany.name)
					
					let company = Company(context: privateContext)
					company.name = jsonCompany.name
					
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "MM/dd/yyyy"
					let foundedDate = dateFormatter.date(from: jsonCompany.founded)
					
					company.founded = foundedDate
					
					jsonCompany.employees?.forEach({ (jsonEmployee) in
						print("  \(jsonEmployee.name)")
						
						let employee = Employee(context: privateContext)
						employee.name = jsonEmployee.name
						employee.type = jsonEmployee.type
						
						let employeeInformation = EmployeeInformation(context: privateContext)
						let birthDate = dateFormatter.date(from: jsonEmployee.birthday)
						employeeInformation.birthday = birthDate
						
						employee.employeeInformation = employeeInformation
						
						employee.company = company
						
					})
					
					do {
						try privateContext.save()
						try  privateContext.parent?.save()
					} catch let saveError {
						print("Failed to save companies: ", saveError)
					}
				})
				
			} catch let jsonDecoderError {
				print("Failed to decode: ", jsonDecoderError)
			}
		}.resume()
	}
}

struct JSONCompany: Decodable {

	let name: String
	let founded : String
	var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
	
	let name: String
	let type: String
	let birthday: String
}
