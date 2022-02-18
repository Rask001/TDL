//
//  NewListVC.swift
//  TDL
//
//  Created by Антон on 03.02.2022.
//

import UIKit

//var dateDate = Date()
class NewListVC: UIViewController, UITextFieldDelegate{

	

	
	//MARK: - Properties
//	let picker = UIPickerView()
	let textField = UITextField()
	let navigationBar = UINavigationBar()
	let leftButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancelFunc))
	let rightButton = UIBarButtonItem(title: "continue", style: .plain, target: self, action: #selector(continueFunc))
	let dataPicker = UIDatePicker()
	
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
		pickerSetup()
		switchAlertSetup()
		switchAlertRepeatSetup()
	}
	
	
	//MARK: - Setup
	func pickerSetup() {
		let dateNow = Date()
//		let dateComponentsNow = dataPicker.calendar.dateComponents([.month, .day, .hour, .minute], from: dateNow)
//		let dateFormatter = DateFormatter()
//		dateFormatter.locale = Locale(identifier: "ru_RU")
//		dateFormatter.dateFormat = "MMM d, HH:mm"
//		let formatDate = dateFormatter.string(from: dateNow)
		dataPicker.isEnabled = false
		dataPicker.minimumDate = dateNow
		dataPicker.timeZone = .autoupdatingCurrent
		self.dataPicker.frame = CGRect(x: self.view.bounds.width/2 - 210, y: 200, width: 300, height: 50)
		self.view.addSubview(dataPicker)
		dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
		
	}
	
	@objc func dataPickerChange(paramDataPicker:UIDatePicker) {
		if paramDataPicker.isEqual(self.dataPicker) {
			let dateFromDP = paramDataPicker.date
//			let dateComponentsChange = dataPicker.calendar.dateComponents([.month, .day, .hour, .minute], from: dateFromDP)
			let dateFormatter = DateFormatter()
			//dateFormatter.locale = Locale(identifier: "ru_RU")
			dateFormatter.dateFormat = "HH:mm"
			let formatDate = dateFormatter.string(from: dateFromDP)
			dateFromDatePicker = formatDate
			newDate = dateFromDP
			print (newDate)
		}
	}
	
	
	func switchAlertSetup(){
		switchAlert.frame = CGRect(x: 30, y: 210, width: 0, height: 0)
		switchAlert.isOn = false
		switchAlert.addTarget(self, action: #selector(reminder), for: .valueChanged)
		self.view.addSubview(switchAlert)
	}
	
	func switchAlertRepeatSetup(){
		switchAlertRepeat.frame = CGRect(x: 30, y: 260, width: 0, height: 0)
		switchAlertRepeat.isOn = false
		switchAlertRepeat.addTarget(self, action: #selector(repeatReminder), for: .valueChanged)
		self.view.addSubview(switchAlertRepeat)
	}
	
	@objc func reminder(){
		if switchAlert.isOn == true {
			dataPicker.isEnabled = true
		}else{
			dataPicker.isEnabled = false
		}
	}
	
	@objc func repeatReminder(){
		print("тут будут повторы")
	}
	//textFieldSetup
	func textFieldSetup() {
		self.textField.delegate = self
		//		self.textField.becomeFirstResponder()
		self.textField.frame = CGRect(x: self.view.bounds.size.width/2 - 150, y: 80, width: 300, height: 31)
		self.textField.placeholder = "craete new task"
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
		textTaskFromTF = text
		let time = dateFromDatePicker
		dateFromDatePicker = time
		NotificationCenter.default.post(name: Notification.Name("Task"), object: .none)
		cancelFunc()
	}
	
	
	@objc func cancelFunc(){
		dismiss(animated: true, completion: nil)
		self.textField.text = ""
	}
}
extension NewListVC: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 10
	}
}
