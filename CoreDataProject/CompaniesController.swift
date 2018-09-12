//
//  CompaniesController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 11/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {
	
	let cellId = "cellId"
	let companies = [
		Company(name: "Apple", founded: Date()),
		Company(name: "Google", founded: Date()),
		Company(name: "Facebook", founded: Date())
	]

	override func viewDidLoad() {
		super.viewDidLoad()
	
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

