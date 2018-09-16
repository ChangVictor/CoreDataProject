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
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
		
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

