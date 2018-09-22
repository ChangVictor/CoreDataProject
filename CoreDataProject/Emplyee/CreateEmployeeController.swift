//
//  CreateEmployeeController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

protocol  CreateEmployeeControllerDelegate {
	func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
	
	var delegate: CreateEmployeeControllerDelegate?
	var company: Company? 
	
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
	
	let birthDayLabel: UILabel = {
		let label = UILabel()
		label.text = "Birthday"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let birthDayTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "MM/DD/YYYY"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		view.backgroundColor = UIColor.darkBlue
		
		setupCancelButton()

		setupUI()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
	}
	
	@objc fileprivate func handleSave() {
		print("Saving employee")
		guard let employeeName = nameTextField.text else { return }
		guard let company = self.company else { return }
		guard let birthdayText = birthDayTextField.text else { return }
		guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }

		// perform validation
		if birthdayText.isEmpty {
			showError(title: "Empty Birthday", message: "Please insert a birthday date")
			return
		}
		
		// turn birthdatTextField into date object
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		
		guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
			showError(title: "Invalid Date", message: "Please insert a valid date")
			return }
		
		
		let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
		
		if let error = tuple.1 {
			print(error)
		} else {
			
			dismiss(animated: true) {
				self.delegate?.didAddEmployee(employee: tuple.0!)
			}
		}
	}
	
	private func showError(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
		return
	}
	
	let employeeTypeSegmentedControl: UISegmentedControl = {
		let types = [
			EmployeeType.Executive.rawValue,
			EmployeeType.SeniorManagement.rawValue,
			EmployeeType.Staff.rawValue
		]
		
		let segmentedControl = UISegmentedControl(items: types)
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.tintColor = UIColor.darkBlue
		return segmentedControl
	}()
	
	fileprivate func setupUI() {
		_ = setupLigthBlueBackgroundView(height: 150)
		
		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(nameTextField)
		nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		nameTextField.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
		nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
		
		view.addSubview(birthDayLabel)
		birthDayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		birthDayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		birthDayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		birthDayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(birthDayTextField)
		birthDayTextField.topAnchor.constraint(equalTo: birthDayLabel.topAnchor).isActive = true
		birthDayTextField.leftAnchor.constraint(equalTo: birthDayLabel.rightAnchor).isActive = true
		birthDayTextField.bottomAnchor.constraint(equalTo: birthDayLabel.bottomAnchor).isActive = true
		birthDayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		
		view.addSubview(employeeTypeSegmentedControl)
		employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthDayLabel.bottomAnchor, constant: 0).isActive = true
		employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
		employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
	}
}
