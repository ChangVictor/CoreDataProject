//
//  UIViewController + Helpers.swift
//  CoreDataProject
//
//  Created by Victor Chang on 16/09/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

extension UIViewController {
	
	// Extension / Helper methods
	func setupPlusButtonInNavBar(selector: Selector) {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
	}
	
	func setupCancelButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
	}
	
	@objc func handleCancelModal() {
		dismiss(animated: true, completion: nil)
	}
}
