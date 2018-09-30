//
//  CompaniesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 11/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
	
	let cellId = "cellId"
	var companies = [Company]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.companies = CoreDataManager.shared.fetchCompanies()
		
		view.backgroundColor = .white
		
		tableView.backgroundColor = .darkBlue
//		tableView.separatorStyle = .none
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
		
		navigationItem.title = "Companies"
		
		setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
			UIBarButtonItem(title: "Nested Update", style: .plain, target: self, action: #selector(doNestedUpdates))
			]
		
	}
	
	@objc fileprivate func doNestedUpdates() {
		print("Trying to perform Nested Updates")
		
		DispatchQueue.global(qos: .background).async {
			
			let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
			
			privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
			
			// execute updates on private context
			let request: NSFetchRequest<Company> = Company.fetchRequest()
			request.fetchLimit = 1
			
			do {
				 let companies = try privateContext.fetch(request)
				
				companies.forEach({ (company) in
					print(company.name ?? "")
					company.name = "D: \(company.name ?? "")"
				})
				
				do {
					try privateContext.save()
					
					DispatchQueue.main.async {
						do {
							let context = CoreDataManager.shared.persistentContainer.viewContext
							
							if context.hasChanges {
								
								try context.save()
							}
							self.tableView.reloadData()

						} catch let finalSaveError {
							print("Failed to save main context: ", finalSaveError)
						}
						
					}
					
				} catch let saveError {
					print("Failed to save private context: ", saveError)
				}
				
				
			} catch let fetchError {
				print("Faild to fetch on private context: ", fetchError )
			}
			
			
			
		}
		
	}
	
	@objc fileprivate func doUpdate() {
		print("Trying to update companies on a background context")
		
		CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
			
			let request: NSFetchRequest<Company> = Company.fetchRequest()
			
			do {
			
				let companies = try backgroundContext.fetch(request)
				
				companies.forEach({ (company) in
					print(company.name ?? "")
					company.name = "C: \(company.name ?? "")"
				})
				
				do {
					try backgroundContext.save()
					
					DispatchQueue.main.async {
						CoreDataManager.shared.persistentContainer.viewContext.reset()
						self.companies = CoreDataManager.shared.fetchCompanies()
						self.tableView.reloadData()
					}
					
				} catch let saveError {
					print("Failed to save on background: ", saveError)
				}
				
			} catch let error {
				
				print("Failed to fetch companies on background: ", error)
			}
			

		}
		
	}
	
	@objc fileprivate func doWork() {
		print("Trying to do work")
	
		CoreDataManager.shared.persistentContainer.performBackgroundTask ({ (backgroundContext) in
			
			(0...5).forEach { (value) in
				print(value)
				let company = Company(context: backgroundContext)
				company.name = String(value)
			}
			
			do {
				try backgroundContext.save()
				
				DispatchQueue.main.async {
					self.companies = CoreDataManager.shared.fetchCompanies()
					self.tableView.reloadData()
				}
				
			} catch let error {
				print("Failed to save: ", error)
			}
			
		})
		
	}
	
	@objc fileprivate func handleReset() {
		print("Attempting to delete all CoreData objects...")
		let context = CoreDataManager.shared.persistentContainer.viewContext
	
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
		
		do {
			try context.execute(batchDeleteRequest)
			// upon deletion from core data
			var indexPathToRemove = [IndexPath]()
			
			for (index, _) in companies.enumerated() {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathToRemove.append(indexPath)
			}
			
			companies.removeAll()
			tableView.deleteRows(at: indexPathToRemove, with: .left)
		

		} catch let deleteError {
			print("Failed to delete objects from CoreData: ", deleteError)
		}
	}
	
	@objc func handleAddCompany() {
		print("Adding company...")
 		let createCompanyController = CreateCompanyController()
		let navController = CustomNavigationController(rootViewController: createCompanyController)
		
		createCompanyController.delegate = self
		present(navController, animated: true, completion: nil)
	}
}

