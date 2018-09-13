//
//  CompaniesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 11/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
	func didAddCompany(company: Company) {
		// in order to add a company, we have to modify the array
		companies.append(company)
		// and insert a new [indesPath] into the tableView
		let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
	
	fileprivate func fetchCompanies() {
		// Attemp to fetch from CoreData
//		let persistentContainer = NSPersistentContainer(name: "DataModel")
//
//		persistentContainer.loadPersistentStores { (storeDescription, error) in
//			if let error = error {
//				fatalError("Loading of store failed: \(error)")
//			}
//		}
//		let context = persistentContainer.viewContext
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
		
		do {
			let companies = try context.fetch(fetchRequest)
			companies.forEach { (company) in
				print(company.name ?? "")
			}
			
			self.companies = companies
			self.tableView.reloadData()

		} catch let fetchError {
			print("Failed to fetch companies: ", fetchError)
		}
	}
	
	let cellId = "cellId"
	var companies = [Company]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchCompanies()
	
		view.backgroundColor = .white
		
		tableView.backgroundColor = .darkBlue
//		tableView.separatorStyle = .none
		tableView.separatorColor = .white
		tableView.tableFooterView = UIView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		
		navigationItem.title = "Companies"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		
	}
	
	@objc func handleAddCompany() {
		print("Adding company...")
 		let createCompanyController = CreateCompanyController()
		let navController = CustomNavigationController(rootViewController: createCompanyController)
		
		createCompanyController.delegate = self
		present(navController, animated: true, completion: nil)
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .lightBlue
		return view
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath)
		
		cell.backgroundColor = .tealColor
		
		let company = companies[indexPath.row]
		cell.textLabel?.text = company.name
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companies.count
	}

}

