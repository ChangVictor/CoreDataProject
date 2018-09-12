//
//  CreateCompanyController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 12/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Company"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		view.backgroundColor = UIColor.darkBlue
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
}
