//
//  NewListViewController.swift
//  TDL
//
//  Created by Антон on 23.01.2022.
//

import UIKit
var textFromTF = ""

class NewListViewController: UIViewController, UITextFieldDelegate {
	
	
	let textField = UITextField()
	let navigationBar = UINavigationBar()
	let leftButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelFunc))
	let rightButton = UIBarButtonItem(title: "continue", style: .plain, target: self, action: #selector(continueFunc))
	
	
	
	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.textField.becomeFirstResponder()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		otherSetup()
		textFieldSetup()
		navigationBarSetup()
	}
	
	
	//MARK: - Setup
	
	//textFieldSetup
	func textFieldSetup() {
		self.textField.delegate = self
		//		self.textField.becomeFirstResponder()
		self.textField.frame = CGRect(x: self.view.bounds.size.width/2 - 150, y: 80, width: 300, height: 31)
		self.textField.placeholder = "craete new folder"
		self.textField.borderStyle = UITextField.BorderStyle.roundedRect
		self.textField.backgroundColor = UIColor(named: "BWTrue")
		self.view.addSubview(self.textField)
	}
	
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.textField.resignFirstResponder()
		continueFunc()
		return true
		//ввод/return на клавиатуре
	}
	
	
	//navigationBarSetup
	func navigationBarSetup() {
		self.navigationBar.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.size.width), height: 44)
		self.navigationBar.backgroundColor = .lightGray
		self.navigationBar.prefersLargeTitles = true
		self.navigationBar.shadowImage = nil
		let navigationItem = UINavigationItem(title: "Create list")
		navigationItem.leftBarButtonItem = leftButton
		navigationItem.rightBarButtonItem = rightButton
		self.navigationBar.items = [navigationItem]
		self.view.addSubview(navigationBar)
	}
	
	//otherSetup
	func otherSetup(){
		self.view.backgroundColor = .secondarySystemBackground
	}
	
	
//MARK: - Func
	@objc func continueFunc(){
		guard let text = textField.text, !text.isEmpty else { return }
		textFromTF = text
		NotificationCenter.default.post(name: Notification.Name("Folder"), object: .none)
		cancelFunc()
	}
	
	
	@objc func cancelFunc(){
		dismiss(animated: true, completion: nil)
		self.textField.text = ""
	}
}
