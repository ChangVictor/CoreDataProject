//
//  CompaniesAutoUpdateController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 01/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate{
	
	
	lazy var fetchResultsController: NSFetchedResultsController<Company> = {
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let request:  NSFetchRequest<Company> = Company.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "name", ascending: true)
		]
		
		let fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		
		fetchRC.delegate = self
		
		do {
			try fetchRC.performFetch()
		} catch let error {
			print(error)
		}
		
		return fetchRC
		
	}()
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
		case .delete:
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		case .move:
			break
		case .update:
			break
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Company Auto Updates"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
		
		tableView.backgroundColor = UIColor.darkBlue
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
		
		fetchResultsController.fetchedObjects?.forEach({ (company) in
			print(company.name ?? "")
		})
	}
	
	@objc fileprivate func handleAdd() {
		print("Adding company...")
		let context = CoreDataManager.shared.persistentContainer.viewContext
		let company = Company(context: context)
		company.name = "BMW"
		
		try? context.save() // Bad practice
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultsController.sections![section].numberOfObjects
	}
	
	let cellId = "cellId"
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
		
		let company = fetchResultsController.object(at: indexPath)
		cell.textLabel?.text = company.name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
}