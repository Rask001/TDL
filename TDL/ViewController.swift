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
		setupTable()
		setupButton()
		notification()
		notificationEdit()
		setConstraits()
		//longPress()
		//tapObservers()
	}
	
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
		self.saveTask(withTitle: textTaskFromTF, withTime: dateFromDatePicker, withDate: newDate)
		tableView.reloadData()
	}
	func saveTask(withTitle title: String, withTime time: String, withDate date: Date) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let model = Tasks(entity: entity, insertInto: context)
		model.text = title
		model.timeLabel = time
		model.timeLabelDate = newDate
		print (newDate)
		
		do{
			try context.save()
			tasksModels.append(model)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	
	//MARK: - EDIT TASK
	@objc func goToNewListEditing(){
			self.present(newListEditing, animated: true, completion: nil)
		}
	
	func notificationEdit(){
		NotificationCenter.default.addObserver(self, selector: #selector(editTask), name: Notification.Name("Edit"), object: .none)
	}
	@objc func editTask(notificationEdit: NSNotification){
		self.editAndSaveTask(withTitle: newCellName, withTime: dateFromDatePicker, withDate: newDate)
		tableView.reloadData()
	}
	func editAndSaveTask(withTitle title: String, withTime time: String, withDate date: Date) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let model = tasksModels[indexP]
		let title = newCellName
		model.text = title
		model.timeLabel = time
		model.timeLabelDate = date
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	
	
	
	
	
	
	//MARK: - FUNC
	@objc func didTapMenu() {
		menuOpen == false ?
		present(leftMenuNC!, animated: true) :
		leftMenuNC!.dismiss(animated: true, completion: nil)
	}
//	func longPress(){
//	let longpress = UILongPressGestureRecognizer(target: self, action: #selector(edit))
//		longpress.minimumPressDuration = 0.4
//	tableView.addGestureRecognizer(longpress)
//	}
	
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
	
	func tapObservers() {
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
		singleTap.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(singleTap)
	}
	
	
	@objc func tappedSoft() {
		let generator = UIImpactFeedbackGenerator(style: .soft)
		generator.impactOccurred()
	}
	
	@objc func singleTapAction(){
		if menuOpen {
			didTapMenu()
			tappedSoft()
		}
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
		self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 50, y: 650, width: 100, height: 50)
		self.buttonNewTask.backgroundColor = .blue
		self.buttonNewTask.titleLabel?.font = UIFont(name: "Avenir Next", size: 17)
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor.white, for: .normal)
		self.buttonNewTask.layer.cornerRadius = 20
		self.buttonNewTask.addTarget(self, action: #selector(goToNewList), for: .touchUpInside)
		//self.buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
		view.addSubview(self.buttonNewTask)
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
		let rightButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
																			style: .plain,
																			target: self,
																			action: #selector(edit))
		self.navigationItem.rightBarButtonItem = rightButton
	}
	
	
	
//	func interactivePopGestureRecognizer(){ //распознователь жестов
//	navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//	}
	
	
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
		self.tableView.register(TableViewCell.self, forCellReuseIdentifier: indentifire)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = UIColor(named: "BGColor")
		//self.tableView.isScrollEnabled = true // скроллинг
		self.tableView.bounces = false //если много ячеек прокрутка on. по дефолту off
		self.tableView.separatorStyle = .none
		self.tableView.rowHeight = 60
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
//		view.addSubview(tableView)
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
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let index = indexPath.row
		
		context.delete(tasksModels[index] as NSManagedObject)
		tasksModels.remove(at: index)
		
		let _ : NSError! = nil
		do {
			try context.save()
			self.tableView.reloadData()
		} catch {
			print("error : \(error)")
		}
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
		let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath) as! TableViewCell
		let task = tasksModels[indexPath.row]
		cell.taskTitle.text = task.text
		cell.taskTime.text = task.timeLabel
		
		cell.buttonCell.tag = indexPath.row
		cell.buttonCell.addTarget(self, action: #selector(printy(sender:)), for: .touchUpInside)
    //task.timeLabelDate = newDate
	  return cell
	}
	
	@objc func printy(sender: UIButton){
		let rowIndex = sender.tag
		print(rowIndex)
	}
	
	@objc func edit(Recognizer: UILongPressGestureRecognizer) {
		tableView.isEditing = !tableView.isEditing
		tappedSoft()
//		if Recognizer.state == .began {
//		tappedHeavy()
//		tableView.isEditing = !tableView.isEditing
//	} else if
//		Recognizer.state == .ended{
		//tappedRigid()
}
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let item = tasksModels[sourceIndexPath.row] //подняли наш айтем
		tasksModels.remove(at: sourceIndexPath.row) //удалили с того места где он был
		tasksModels.insert(item, at: destinationIndexPath.row) // положили на новое место
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
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
			tableView.topAnchor.constraint(equalTo: showHeightButton.bottomAnchor, constant: 5),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5)
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

