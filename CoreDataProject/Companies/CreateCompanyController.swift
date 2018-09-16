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

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
	
	var company: Company? {
		didSet {
			nameTextField.text = company?.name
			if let imageData = company?.imageData {
				companyImageView.image = UIImage(data: imageData)
				setupCircularImageStyle()
			}
			
			guard let founded = company?.founded else { return }
			datePicker.date = founded
		}
	}
	
	fileprivate func setupCircularImageStyle() {
		companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
		companyImageView.clipsToBounds = true
		companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
		companyImageView.layer.borderWidth = 2
	}
	var delegate: CreateCompanyControllerDelegate?
//	var companiesController: CompaniesController?
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "Name"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var companyImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
		return imageView
	}()
	
	@objc fileprivate func handleSelectPhoto() {
		print("Trying to select photo...")
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		print(info)
		
		if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			
			companyImageView.image = editedImage
			
		} else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			companyImageView.image = originalImage
		}
		setupCircularImageStyle()
		dismiss(animated: true, completion: nil)
	}
	
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
		
		setupCancelButton()
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
		lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350).isActive = true
		
		view.addSubview(companyImageView)
		companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
		companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		
		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
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
		if let companyImage = companyImageView.image {
			let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
			company?.imageData = imageData
		}
		
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
		
		if let companyImage = companyImageView.image {
			
			let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
			company.setValue(imageData, forKey: "imageData")
			
		}
		
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
}
