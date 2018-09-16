//
//  EmployeesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
	
	var company: Company?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.backgroundColor = UIColor.darkBlue
		
		setupPlusButtonInNavBar(selector: #selector(handleAdd))
	}
	
	@objc private func handleAdd() {
		print("Trying to add an employee")
		
		let createEmployeeController = CreateEmployeeController()
		let navController = UINavigationController(rootViewController: createEmployeeController)
		
		present(navController, animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = company?.name
	}
}
