//
//  CreateEmployeeController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		view.backgroundColor = UIColor.darkBlue
		
		setupCancelButton()
		
	}
}
