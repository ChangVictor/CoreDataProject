//
//  CompaniesController+CreateCompany.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
	
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
	
}

