//
//  SecondVC.swift
//  TDL
//
//  Created by Антон on 26.01.2022.
//

import UIKit

class SecondVC: UIViewController {
	let navigationBar = UINavigationBar()
	let leftButton = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteAll))
	let rightButton = UIBarButtonItem(title: "setting", style: .plain, target: self, action: #selector(editFolders))
	//(title: "delete", style: .plain, target: self, action: #selector(deleteAll))
	override func viewDidLoad() {
		super.viewDidLoad()
		otherSetup()
		navigationBarSetup()
	}
	
	
	@objc func deleteAll() {
		print("hello")
	}
	
	@objc func editFolders () {
		
	}
	
	func navigationBarSetup() {
		self.navigationItem.leftBarButtonItem = leftButton
		self.navigationItem.rightBarButtonItem = rightButton
		self.navigationItem.title = "In development"
	}
	
	
	
	
	func otherSetup() {
		self.view.backgroundColor = .secondarySystemBackground
		let tabBarItem = UITabBarItem(title: nil,
															image: UIImage(systemName: "xmark.seal")?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)),
															tag: 1)
		self.tabBarItem = tabBarItem
	}
	
	
	
}
