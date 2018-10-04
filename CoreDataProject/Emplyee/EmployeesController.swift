//
//  EmployeesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
	
	override func drawText(in rect: CGRect) {
		let inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
		let customRect = UIEdgeInsetsInsetRect(rect, inset)
		super.drawText(in: customRect)
	}
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
	
	// didAddEmployee is called when we dismiss employee creation
	func didAddEmployee(employee: Employee) {
		guard let employeeType = employee.type else { return }
		guard let section = employeeTypes.index(of: employeeType) else { return }
		let row = allEmployees[section].count
		
		let insertionIndexPath = IndexPath(row: row, section: section)
		
		allEmployees[section].append(employee)
		
		tableView.insertRows(at: [insertionIndexPath], with: .middle)
	}
	
	var company: Company?
	var allEmployees = [[Employee]]()
	var employeeTypes = [
		EmployeeType.Executive.rawValue,
		EmployeeType.SeniorManagement.rawValue,
		EmployeeType.Staff.rawValue
	]

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
		
		allEmployees = []

		employeeTypes.forEach { (employeeTypes) in
			
			allEmployees.append(companyEmployeee.filter { $0.type == employeeTypes} )
			
		}
//
//		let executives = companyEmployeee.filter { (employee) -> Bool in
//			return employee.type == EmployeeType.Executive.rawValue
//		}
//
//		let seniorManagement = companyEmployeee.filter { $0.type == EmployeeType.SeniorManagement.rawValue }
//
//		allEmployees = [
//			executives,
//			seniorManagement,
//			companyEmployeee.filter { $0.type == EmployeeType.Staff.rawValue }
//		]
//
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = company?.name
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return allEmployees.count
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = IndentedLabel()
//		if section == 0 {
//			label.text = EmployeeType.Executive.rawValue
//		} else if section == 1{
//			label.text = EmployeeType.SeniorManagement.rawValue
//		} else {
//			label.text = EmployeeType.Staff.rawValue
//		}
		label.text = employeeTypes[section]
		
		label.backgroundColor = UIColor.lightBlue
		label.textColor = UIColor.darkBlue
		label.font = UIFont.boldSystemFont(ofSize: 16)
		return label
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return allEmployees[section].count
//		if section == 0 {
//			return shortNameEmployees.count
//		}
//		return longNameEmployees.count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
	
		// ternary operator
//		let employee = employees[indexPath.row]
		let employee = allEmployees[indexPath.section][indexPath.row ]
		cell.textLabel?.text = employee.fullName
		
//		if let taxId = employee.employeeInformation?.taxId {
//			cell.textLabel?.text = "\(employee.name ?? "")   \(taxId)"
//		}
		if let birthday = employee.employeeInformation?.birthday {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			cell.textLabel?.text = "\(employee.fullName ?? "")   \(dateFormatter.string(from: birthday))"

		}
		
		cell.backgroundColor = UIColor.tealColor
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
		
		return cell
	}
}
