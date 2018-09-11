//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Victor Chang on 11/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white
		
		navigationItem.title = "Companies"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
		
		setupNavigationStyle()
		
	}
	
	@objc func handleAddCompany() {
		print("Adding company...")
	}
	
	fileprivate func setupNavigationStyle() {
		navigationController?.navigationBar.isTranslucent = false
		let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
		navigationController?.navigationBar.barTintColor = lightRed
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		
	}

}

