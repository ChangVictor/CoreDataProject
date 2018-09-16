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
	
	func didEditCompany(company: Company) {
		// update tableView
		guard let row = companies.index(of: company) else { return }
		let reloadIndexPath = IndexPath(row: row, section: 0)
		tableView.reloadRows(at: [reloadIndexPath], with: .middle)
	}
	
	func didAddCompany(company: Company) {
		// in order to add a company, we have to modify the array
		companies.append(company)
		// and insert a new [indesPath] into the tableView
		let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .automatic)
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
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
		
		navigationItem.title = "Companies"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
		
	}
	
	@objc fileprivate func handleReset() {
		print("Attempting to delete all CoreData objects...")
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
//		companies.forEach { (company) in
//			context.delete(company)
//
//		}
		
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
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let label = UILabel()
		label.text = "No companies available..."
		label.textColor = .white
		label.textAlignment = .center
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return companies.count == 0 ? 150 : 0
	}
	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
			let company = self.companies[indexPath.row]
			print("Attempting to delete company: ", company.name ?? "")
			
			// remove the company from tableView
			self.companies.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			
			// delete the company from CoreData
			let context = CoreDataManager.shared.persistentContainer.viewContext
			
			context.delete(company)
			
			do {
				try context.save()
			} catch let saveError {
				print("Failed to delete company: ", saveError)
			}

		}
		
		let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
		
		deleteAction.backgroundColor = UIColor.lightRed
		editAction.backgroundColor = UIColor.darkBlue
		
		return [deleteAction, editAction]
	}
	
	
	private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
		print("Editing company in separate function")
		
		let editCompanyController = CreateCompanyController()
		editCompanyController.delegate = self
		editCompanyController.company = companies[indexPath.row]
		let navController = CustomNavigationController(rootViewController: editCompanyController)
		present(navController, animated: true, completion: nil )
	}
	
	fileprivate func fetchCompanies() {
		// Attemp to fetch from CoreData
		//
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

	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .lightBlue
		return view
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! CompanyCell
		
		let company = companies[indexPath.row]
		cell.company = company
		

//		
//		cell.textLabel?.textColor = .white
//		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//		cell.imageView?.image = #imageLiteral(resourceName: "select_photo_empty")
//
//		
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companies.count
	}

}
