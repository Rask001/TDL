//
//  ViewController.swift
//  TDL
//
//  Created by Антон on 23.01.2022.
//
import SideMenu
import UIKit
import CoreData
import FSCalendar

var menuOpen = false
var checkmark = false
var alarmLabelBoolGlobal = false
var repeatLabelBoolGlobal = false
var textTaskFromTF = ""
var dateFromDatePicker = ""
var newDate = Date()
var oldDate = Date()
var newCellName = ""
var oldCellName = ""
var switchAlert = UISwitch()
var switchAlertRepeat = UISwitch()
class ViewController: UIViewController {
	
	
	//MARK: - Properties
	private var tasksModels: [Tasks] = []
	let newList = NewListVC()
	let newListEditing = NewListEditing()
	var leftMenuNC: SideMenuNavigationController?
	var tableView = UITableView()
	let indentifire = "Cell"
	let buttonNewTask = UIButton(type: .system)
	var indexP = 0
	let calendar = FSCalendar ()
	var calendarHeightConstraint : NSLayoutConstraint!
	
	let showHeightButton = UIButton()

	
	//MARK: - viewWillAppear
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest() //используем классовый метод
		do{
			tasksModels = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	//MARK: - viewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animateTableView()
	}
	
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSideMenu()
  	setupNavigationItems()
		calendarSetup()
		showHeightButtonSetup()
		setupOther()
		swipesObservers()
		swipeCalendar()
		setupButton()
		setupTable()
		notification()
		notificationEdit()
		setConstraits()
		//longPress()
		//tapObservers()
	}
	

	//MARK: - NEW TASK
	@objc func goToNewList(){
			self.present(newList, animated: true, completion: nil)
			//экшен для кнопки презентующий модально NewList
		}
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(addNewTask), name: Notification.Name("Task"), object: .none)
		//переносит введеный текст из newListVC в viewContrioller
	}
	@objc func addNewTask(notification: NSNotification){
		self.saveTask(withTitle: textTaskFromTF,
									withTime: dateFromDatePicker,
									withDate: newDate,
									withCheck: checkmark,
									withAlarmLabelBuul: alarmLabelBoolGlobal,
									withRepeatLabelBool: repeatLabelBoolGlobal)
	
		tableView.reloadData()
	}
	
	
	func saveTask(withTitle title: String, withTime time: String, withDate date: Date, withCheck check: Bool, withAlarmLabelBuul alarm: Bool, withRepeatLabelBool repeatt: Bool) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		//let ex = TableViewCell()
		model.text = title
		model.timeLabel = time
		model.timeLabelDate = newDate
		model.check = false
	  model.alarmLabelBool = alarm
		model.repeatLabelBool = repeatt
		
		do{
			try context.save()
			tasksModels.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
    }
		
		sendReminderNotification("Напоминание \(time)", title, newDate)
	}
 
	
	
	
	//MARK: - EDIT TASK
	@objc func goToNewListEditing(){
			self.present(newListEditing, animated: true, completion: nil)
		}
	
	func notificationEdit(){
		NotificationCenter.default.addObserver(self, selector: #selector(editTask), name: Notification.Name("Edit"), object: .none)
	}
	@objc func editTask(notificationEdit: NSNotification){
		self.editAndSaveTask(withTitle: newCellName, withTime: dateFromDatePicker, withDate: newDate, withCheck: checkmark)
		tableView.reloadData()
		print("проверка")
	}
	func editAndSaveTask(withTitle title: String, withTime time: String, withDate date: Date, withCheck check: Bool) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let model = tasksModels[indexP]
		let title = newCellName
		model.text = title
		model.timeLabel = time
		model.timeLabelDate = date
		model.check = false
		model.alarmLabelBool = alarmLabelBoolGlobal
		model.repeatLabelBool = repeatLabelBoolGlobal

		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		sendReminderNotification("Напоминание \(time)", title, date)
	}
	
	
	//MARK: - FUNC
	@objc func didTapMenu() {
		menuOpen == false ?
		present(leftMenuNC!, animated: true) :
		leftMenuNC!.dismiss(animated: true, completion: nil)
	}
	
	func swipesObservers() {
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
		swipeLeft.direction = .left
		self.view.addGestureRecognizer(swipeLeft)
	}
	
	func swipeCalendar() {
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipesCalendar))
		swipeUp.direction = .up
		self.calendar.addGestureRecognizer(swipeUp)
		
		let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipesCalendar))
		swipeDown.direction = .down
		self.calendar.addGestureRecognizer(swipeDown)
	}
	
	@objc func handleSwipesCalendar(gesture: UISwipeGestureRecognizer) {
		switch gesture.direction {
		case .up:
			if calendar.scope == .month {
				showHeightButtonTapped()
			}
		case .down:
			if calendar.scope == .week{
			showHeightButtonTapped()
			}
		default:
			break
		}
	}
	
	
	
	@objc func tappedSoft() {
		let generator = UIImpactFeedbackGenerator(style: .soft)
		generator.impactOccurred()
	}
	
	@objc func tappedRigid() {
		let generator = UIImpactFeedbackGenerator(style: .rigid)
		generator.impactOccurred()
	}
	
	
	
	@objc func handleSwipes(gester: UISwipeGestureRecognizer){
		switch gester.direction {
		case .right:
			break
		case .left:
			menuOpen == true ? didTapMenu() : nil
		case .up:
			break
		case .down:
			break
		default:
			break
		}
	}
	
	func calendarSetup(){
		self.calendar.translatesAutoresizingMaskIntoConstraints = false
		self.calendar.dataSource = self
		self.calendar.delegate = self
		self.calendar.scope = .week
	}
	
	func showHeightButtonSetup() {
		self.showHeightButton.addTarget(self, action: #selector(showHeightButtonTapped), for: .touchUpInside)
		self.showHeightButton.setTitle("Open calendar", for: .normal)
		self.showHeightButton.setTitleColor(UIColor.gray, for: .normal)
		self.showHeightButton.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
		self.showHeightButton.translatesAutoresizingMaskIntoConstraints = false
	} 

	//MARK: - SETUP
	
	func setupButton(){
		self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 50, y: 670, width: 100, height: 50)
		self.buttonNewTask.backgroundColor = UIColor(named: "BlackWhite")
		self.buttonNewTask.titleLabel?.font = UIFont(name: "Avenir Next", size: 17)
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor.white, for: .normal)
		self.buttonNewTask.layer.cornerRadius = 20
		self.buttonNewTask.addTarget(self, action: #selector(goToNewList), for: .touchUpInside)
		//self.buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
		tableView.addSubview(buttonNewTask)
	}
	
	
	//SideMenu
	private func setupSideMenu(){
		let menuWidth: CGFloat = 314
		leftMenuNC = SideMenuNavigationController(rootViewController: LeftMenuVC())
		SideMenuManager.default.leftMenuNavigationController = leftMenuNC
		SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
		leftMenuNC?.presentationStyle = .viewSlideOutMenuIn // стиль открытия меню
		leftMenuNC?.presentingViewControllerUserInteractionEnabled = true //представление ViewController Взаимодействие с пользователем включено
		leftMenuNC?.enableSwipeToDismissGesture = false //можно ли свайпать меню
		leftMenuNC?.enableTapToDismissGesture = true
		leftMenuNC?.menuWidth = menuWidth
	}
	
	//NavigationItems
	private func setupNavigationItems(){
		self.title = "Your tasks"
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"),
																														style: .plain,
																														target: self,
																														action: #selector(didTapMenu))
		let rightButton = UIBarButtonItem(image: UIImage(systemName: "bell"),
																			style: .plain,
																			target: self,
																			action: #selector(showHeightButtonTapped))
		self.navigationItem.rightBarButtonItem = rightButton
	}
	
	
	

	
	
	//setupOther
	private func setupOther(){
		self.view.backgroundColor = UIColor(named: "BGColor")
		let tabBarItem = UITabBarItem(title: nil,
																	image: UIImage(systemName: "checkmark.seal")?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)),
																	tag: 0)
		self.tabBarItem = tabBarItem
		
	
		
	}
	
	
	@objc func showHeightButtonTapped(){
		if calendar.scope == .week {
			calendar.setScope(.month, animated: true)
			showHeightButton.setTitle("Close calendar", for: .normal)
		} else {
			calendar.setScope(.week, animated: true)
			showHeightButton.setTitle("Open calendar", for: .normal)
		}
	}
	
	
	//MARK: - TABLE VIEW
	
	
	func setupTable() {
		self.tableView = UITableView()
//		self.tableView.frame = CGRect(x: 10, y: 0, width: 0, height: 0)
		self.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = .clear//UIColor(named: "BGColor")
		//self.tableView.isScrollEnabled = true // скроллинг
		self.tableView.bounces = true //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle = .none
		self.tableView.rowHeight = 60
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		//view.addSubview(tableView)
	}
	

	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//tableView.deselectRow(at: indexPath, animated: true) //Затухание выбора ячейки
		let task = tasksModels[indexPath.row]
		let text = task.text
		indexP = indexPath.row
		oldCellName = text
		goToNewListEditing()
	}
	
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let editButton = UIContextualAction(style: .normal, title: "") { action, view, completion in
			let task = self.tasksModels[indexPath.row]
			let text = task.text
			oldDate = task.timeLabelDate!
			self.indexP = indexPath.row
			oldCellName = text
			self.goToNewListEditing()
		}
		editButton.backgroundColor = UIColor.darkGray
		editButton.image = UIImage.init(systemName: "pencil")
		
		let editButton2 = UIContextualAction(style: .normal, title: "") { action, view, completion in
		}
		editButton2.image = UIImage.init(systemName: "star")
	  editButton2.backgroundColor = UIColor.green
	
		return UISwipeActionsConfiguration(actions: [editButton, editButton2])
	}
	
	
	
	//MARK: Delete Cell
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		tappedRigid()
		let task = tasksModels[indexPath.row]
		let nameCell = task.text
		let areYouSureAllert = UIAlertController(title: "Delete '\(nameCell)'?", message: nil, preferredStyle: .actionSheet)
		let yesAction = UIAlertAction(title: "Delete", style: .destructive){
			[self] action in
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let index = indexPath.row
			
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(nameCell)"])
			
		context.delete(tasksModels[index] as NSManagedObject)
		tasksModels.remove(at: index)
		
		let _ : NSError! = nil
		do {
			self.tableView.deleteRows(at: [indexPath], with: .left)
			
			
			try context.save()
			self.tableView.reloadData()
		} catch {
			print("error : \(error)")
		}
	}

		let noAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
		}
		areYouSureAllert.addAction(yesAction)
		areYouSureAllert.addAction(noAction)
		present(areYouSureAllert, animated: true)
	}

	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasksModels.count
	}

	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60.0
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
		let task = tasksModels[indexPath.row]
		let button = cell.buttonCell
		let timeLabelDate = task.timeLabelDate
		
		cell.taskTitle.text = task.text
		cell.taskTime.text = task.timeLabel
    button.tag = indexPath.row
		cell.alarmImageView.isHidden = task.alarmLabelBool
		cell.repeatImageView.isHidden = task.repeatLabelBool
		
		if task.check == false {
			button.backgroundColor = UIColor(named: "BGColor")
			button.setImage(nil, for: .normal)
			if timeLabelDate ?? Date() < Date() {
				cell.repeatImageView.tintColor = .red
				cell.alarmImageView.tintColor = .red
				cell.taskTime.textColor = .red
				cell.taskTitle.textColor = .red
				cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
			}else{
			cell.taskTitle.textColor = .black
			cell.taskTime.textColor = UIColor(white: 0.5, alpha: 1)
			cell.repeatImageView.tintColor = UIColor(white: 0.5, alpha: 1)
			cell.alarmImageView.tintColor = UIColor(white: 0.5, alpha: 1)
			cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: nil ?? ""])
			}
			sendReminderNotification("Напоминание \(task.timeLabel!)", task.text, task.timeLabelDate!)
		}else{
			button.backgroundColor = UIColor.white
			button.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
			button.tintColor = .lightGray
			cell.taskTitle.textColor = .lightGray
			cell.taskTime.textColor = .lightGray
			cell.repeatImageView.tintColor = .lightGray
			cell.alarmImageView.tintColor = .lightGray
			cell.taskTitle.attributedText = NSAttributedString(string: "\(cell.taskTitle.text!)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id_\(task.text)"])
		}
		button.addTarget(self, action: #selector(saveCheckmark(sender:)), for: .touchUpInside)
		return cell
		
	}
	
	
	
	@objc func saveCheckmark(sender: UIButton) {
		tappedSoft()
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let model = tasksModels[sender.tag]
		if checkmark == model.check{
			model.check = !checkmark
		}else{
			model.check = checkmark
		}
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		tableView.reloadData()
	}
	

	
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let item = tasksModels[sourceIndexPath.row] //подняли наш айтем
		tasksModels.remove(at: sourceIndexPath.row) //удалили с того места где он был
		tasksModels.insert(item, at: destinationIndexPath.row) // положили на новое место
	}
	
	func animateTableView(){
		tableView.reloadData()
		let cells = tableView.visibleCells
		let tableViewHeight = tableView.bounds.height
		let tableViewHeightMinus = -tableViewHeight-20
		//- (tableViewHeight * 2)
		var delay: Double = 0
		for cell in cells {
			cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeightMinus)
			
			UIView.animate(withDuration: 0.7,
										 delay: delay * 0.08,
										 usingSpringWithDamping: 0.8,
										 initialSpringVelocity: 0,
										 options: .curveEaseInOut,
										 animations: {
				cell.transform = CGAffineTransform.identity
			})
			delay += 1
		}
	}
}

//MARK: - Set Constrains
extension ViewController {
	
	func setConstraits() {
		view.addSubview(calendar)
		calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy:  .equal, toItem: nil, attribute:  .notAnAttribute, multiplier: 1, constant: 300)
		calendar.addConstraint(calendarHeightConstraint)
		NSLayoutConstraint.activate([
			calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
			calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
		])
		view.addSubview(showHeightButton)
		NSLayoutConstraint.activate([
			showHeightButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
			showHeightButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			showHeightButton.widthAnchor.constraint(equalToConstant: 100),
			showHeightButton.heightAnchor.constraint(equalToConstant: 20 )
		])
		view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
			tableView.topAnchor.constraint(equalTo: showHeightButton.bottomAnchor, constant: 5),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
		])
		view.addSubview(buttonNewTask)
		NSLayoutConstraint.activate([
		])
	}
}
//MARK: - EXTENTION
extension ViewController: FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		calendarHeightConstraint.constant = bounds.height
		view.layoutIfNeeded()
	}
	
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		print(date)
	}
}

//MARK: Commention Func

//	func interactivePopGestureRecognizer(){ //распознователь жестов
//	navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//	}


//	func longPress(){
//	let longpress = UILongPressGestureRecognizer(target: self, action: #selector(edit))
//		longpress.minimumPressDuration = 0.4
//	tableView.addGestureRecognizer(longpress)
//	}


//	func tapObservers() {
//		let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
//		singleTap.numberOfTapsRequired = 1
//		self.view.addGestureRecognizer(singleTap)
//	}

//	@objc func singleTapAction(){
//		print("koko yopta")
//		if menuOpen {
//			didTapMenu()
//			tappedSoft()
//		}
