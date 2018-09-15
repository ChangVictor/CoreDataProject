//
//  CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 12/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import CoreData

// Custom Delegation

protocol CreateCompanyControllerDelegate {
	func didAddCompany(company: Company)
	func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
	
	var company: Company? {
		didSet {
			
			guard let founded = company?.founded else { return }
			nameTextField.text = company?.name
			datePicker.date = founded
		}
	}
	var delegate: CreateCompanyControllerDelegate?
//	var companiesController: CompaniesController?
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let nameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter name..."
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	let datePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		return datePicker
	}()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company == nil ? "Create Company" : "Edit Company"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
		
		view.backgroundColor = UIColor.darkBlue
		
		
		setupUI()
	}
	
	fileprivate func setupUI() {
		
		let lightBlueBackgroundView = UIView()
		lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
		lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(lightBlueBackgroundView)
		lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 250).isActive = true
		
		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
//		nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(nameTextField)
		nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		nameTextField.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
		nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
		
		view.addSubview(datePicker)
		datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
		datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}
	
	@objc func handleSave() {
		if company == nil {
			createCompany()
		} else {
			saveCompanyChanges()
		}
	}
	
	fileprivate func saveCompanyChanges() {
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		company?.name = nameTextField.text
		company?.founded = datePicker.date
		
		do {
			
			try context.save()
			dismiss(animated: true) {
				self.delegate?.didEditCompany(company: self.company!)
			}

		} catch let saveError {
			print("Failed to save company changes: ", saveError)
		}
	}
	
	fileprivate func createCompany() {
		// Initialization of CoreData stack
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		company.setValue(nameTextField.text, forKey: "name")
		company.setValue(datePicker.date, forKey: "founded")
		
		// Perform the save
		do {
			try context.save()
			
			dismiss(animated: true) {
				
				self.delegate?.didAddCompany(company: company as! Company)
			}
		} catch let saveError {
			print("Failed to save company: ", saveError)
		}
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
}
