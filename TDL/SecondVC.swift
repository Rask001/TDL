//
//  SecondVC.swift
//  TDL
//
//  Created by Антон on 26.01.2022.
//

import UIKit

class SecondVC: UIViewController {
	let navigationBar = UINavigationBar()
	let settingsViewController = SettingsViewController()
//	let leftButton = UIBarButtonItem(title: "delete", style: .plain, target: self, action: #selector(deleteAll))
//	let rightButton = UIBarButtonItem(title: "setting", style: .plain, target: self, action: #selector(editFolders))
	let button = UIButton(type: .system)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		otherSetup()
	 // navigationBarSetup()
		setupButton()
	}
	
	func setupButton(){
		button.frame = CGRect(x: self.view.bounds.width/2 - 60, y: 670, width: 120, height: 50)
		button.addTarget(self, action: #selector(editFolders), for: .touchUpInside)
		button.backgroundColor = UIColor(named: "BlackWhite")
		button.setTitle("Setting", for: .normal)
		button.titleLabel?.font = UIFont(name: "Futura", size: 17)
		button.setTitleColor(UIColor(named: "BWTrue"), for: .normal)
		button.layer.cornerRadius = 10
		self.view.addSubview(button)
	}
	
	
	@objc func deleteAll() {
		print("hello")
	}
	
	@objc func editFolders() {
		print("ширина вью: \(view.bounds.width), высота: \(view.bounds.height)")
		self.present(settingsViewController, animated: true, completion: nil)
	}
	
//	func navigationBarSetup() {
//		self.navigationItem.leftBarButtonItem = leftButton
//		self.navigationItem.rightBarButtonItem = rightButton
//		self.navigationItem.title = "In development"
//	}
	
	
	
	
	func otherSetup() {
		self.view.backgroundColor = UIColor(named: "BGColor")
		let tabBarItem = UITabBarItem(title: nil,
															image: UIImage(systemName: "xmark.seal")?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)),
															tag: 1)
		self.tabBarItem = tabBarItem
	}
	
	
	
}
