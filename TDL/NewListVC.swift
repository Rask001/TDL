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
		setConstraits()
	}
	
	
	//MARK: - Setup
	func pickerSetup() {
		let dateNow = Date()
		self.dataPicker.isEnabled = false
		self.dataPicker.minimumDate = dateNow
		self.dataPicker.timeZone = .autoupdatingCurrent
		self.dataPicker.translatesAutoresizingMaskIntoConstraints = false
		self.dataPicker.frame = CGRect(x: self.view.bounds.width/2 - 210, y: 200, width: 300, height: 50)
		self.dataPicker.addTarget(self, action: #selector(dataPickerChange(paramDataPicker:)), for: .valueChanged)
		self.view.addSubview(dataPicker)
		
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
		//switchAlert.frame = CGRect(x: 30, y: 210, width: 0, height: 0)
		switchAlert.isOn = false
		switchAlert.translatesAutoresizingMaskIntoConstraints = false
		switchAlert.addTarget(self, action: #selector(reminder), for: .valueChanged)
		self.view.addSubview(switchAlert)
	}
	
	func switchAlertRepeatSetup(){
		//switchAlertRepeat.frame = CGRect(x: 30, y: 260, width: 0, height: 0)
		switchAlertRepeat.isOn = false
		switchAlertRepeat.translatesAutoresizingMaskIntoConstraints = false
		switchAlertRepeat.addTarget(self, action: #selector(repeatReminder), for: .valueChanged)
		self.view.addSubview(switchAlertRepeat)
	}
	
	
	
	@objc func reminder(){

		let exemp = TableViewCell()
		if switchAlert.isOn == true {
			self.dataPicker.isEnabled = true
			alarmLabelBoolGlobal = false
		}else{
			self.dataPicker.isEnabled = false
      alarmLabelBoolGlobal = true
		}
		exemp.alarmImageView.isHidden = alarmLabelBoolGlobal
	}

	
	
	
	@objc func repeatReminder(){
		//guard switchAlert.isOn == true else { return }
		if switchAlertRepeat.isOn == true {
			print ("Repeat on")
			repeatLabelBoolGlobal = false
		}else{
			print ("Repeat off")
			repeatLabelBoolGlobal = true
		}
		print("тут будут повторы")
	}
	
	//textFieldSetup
	func textFieldSetup() {
		self.textField.delegate = self
		//		self.textField.becomeFirstResponder()
		self.textField.frame = CGRect(x: self.view.bounds.size.width/2 - 150, y: 80, width: 300, height: 31)
		self.textField.layer.cornerRadius = 5
		self.textField.placeholder = " craete new task"
		self.textField.borderStyle = UITextField.BorderStyle.none
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
		self.navigationBar.barTintColor = .secondarySystemBackground
		self.navigationBar.prefersLargeTitles = true
		self.navigationBar.shadowImage = .none
		let navigationItem = UINavigationItem(title: "Create task")
		navigationItem.leftBarButtonItem = leftButton
		navigationItem.rightBarButtonItem = rightButton
		self.navigationBar.items = [navigationItem]
		self.view.addSubview(navigationBar)
	}
	
	//otherSetup
	func otherSetup(){
		self.view.backgroundColor = .secondarySystemBackground
		alarmLabelBoolGlobal = true
		repeatLabelBoolGlobal = true
	}
	
	
//MARK: - Func
	@objc func continueFunc(){
		guard let text = textField.text, !text.isEmpty else { return }
		if switchAlert.isOn == true {
			guard dateFromDatePicker != "" else { return }
		}
		textTaskFromTF = text
		NotificationCenter.default.post(name: Notification.Name("Task"), object: .none)
		cancelFunc()
	}

	
	@objc func cancelFunc(){
		self.textField.text = nil
		self.dataPicker.isEnabled = false
		switchAlert.isOn = false
		switchAlertRepeat.isOn = false
		dateFromDatePicker = ""
		alarmLabelBoolGlobal = true
		repeatLabelBoolGlobal = true
		dismiss(animated: true, completion: nil)
	}
}
extension NewListVC: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 10
	}
	
	
	func setConstraits() {
	
		NSLayoutConstraint.activate([
			switchAlert.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
			//switchAlert.trailingAnchor.constraint(equalTo: self.dataPicker.leadingAnchor, constant: -20),
			switchAlert.centerYAnchor.constraint(equalTo: self.dataPicker.centerYAnchor)
		])
		
		NSLayoutConstraint.activate([
			self.dataPicker.leadingAnchor.constraint(equalTo: switchAlert.trailingAnchor, constant: 20),
			self.dataPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
			self.dataPicker.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 130)
		])
		
		NSLayoutConstraint.activate([
			switchAlertRepeat.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
			//switchAlertRepeat.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
			switchAlertRepeat.topAnchor.constraint(equalTo: switchAlert.bottomAnchor, constant: 30)
		])
	}
	
	
}
