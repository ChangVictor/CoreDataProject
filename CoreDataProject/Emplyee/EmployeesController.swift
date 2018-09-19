//
//  EmployeesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
	
	func didAddEmployee(employee: Employee) {
		employees.append(employee)
		tableView.reloadData()
	}
	
	
	var company: Company?
	var employees = [Employee]()
	let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.backgroundColor = UIColor.darkBlue
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
		
		fetchEmployees()
		setupPlusButtonInNavBar(selector: #selector(handleAdd))

	}
	
	@objc private func handleAdd() {
		print("Trying to add an employee")
		
		let createEmployeeController = CreateEmployeeController()
		let navController = UINavigationController(rootViewController: createEmployeeController)
		createEmployeeController.delegate = self
		createEmployeeController.company = company
		present(navController, animated: true, completion: nil)
	}
	
	private func fetchEmployees() {
		guard let companyEmployeee = company?.employees?.allObjects as? [Employee] else { return }
		self.employees = companyEmployeee
//		print("Trying to fecth employees")
//		let context = CoreDataManager.shared.persistentContainer.viewContext
//		let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//		do {
//			let employees = try context.fetch(request)
//
//			self.employees = employees
//			employees.forEach {print("Employee name: ", $0.name ?? "")}
//		} catch let error {
//			print("Failed to fetch employees", error)
//		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = company?.name
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employees.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		let employee = employees[indexPath.row]
		cell.textLabel?.text = employee.name
		
		if let taxId = employee.employeeInformation?.taxId {
			cell.textLabel?.text = "\(employee.name ?? "")   \(taxId)"
		}
		
		cell.backgroundColor = UIColor.tealColor
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
		
		return cell
	}
}
