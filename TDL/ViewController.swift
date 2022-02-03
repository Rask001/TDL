//
//  ViewController.swift
//  TDL
//
//  Created by Антон on 23.01.2022.
//
import SideMenu
import UIKit
import CoreData

var menuOpen = false

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	var tasks: [Tasks] = []
	let newList = NewListVC()
	let newListEditing = NewListEditing()
	var leftMenuNC: SideMenuNavigationController?
	var tableView = UITableView()
	let indentifire = "Cell"
	let buttonNewTask = UIButton(type: .system)
	var navigationItemImage: String = ""
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSideMenu()
  	setupNavigationItems()
		setupOther()
		swipesObservers()
		//tapObservers()
		setupTable()
		setupButton()
		notification()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest() //используем классовый метод
		do{
			tasks = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let index = indexPath.row
		
		context.delete(tasks[index] as NSManagedObject)
		tasks.remove(at: index)
		
		let _ : NSError! = nil
		do {
			try context.save()
			self.tableView.reloadData()
		} catch {
			print("error : \(error)")
		}
	}
	
	
	func saveTask(withTitle title: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let tasksObject = Tasks(entity: entity, insertInto: context)
		tasksObject.text = title
		do{
			try context.save()
			tasks.append(tasksObject)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	
	
	
	
	func editAndSaveTask(withTitle title: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else {return}
		let tasksObject = Tasks(entity: entity, insertInto: context)
		tasksObject.text = newCellName
		do{
			try context.save()
			tasks.append(tasksObject)
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
	
	
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(addNewTask), name: Notification.Name("Task"), object: .none)
		//переносит введеный текст из newListVC в viewContrioller
	}
	func notificationEdit(){
		NotificationCenter.default.addObserver(self, selector: #selector(editTask), name: Notification.Name("Edit"), object: .none)
	
	}
	
	@objc func goToNewList(){
			self.present(newList, animated: true, completion: nil)
			//экшен для кнопки презентующий модально NewList
		}
	
	@objc func goToNewListEditing(){
			self.present(newListEditing, animated: true, completion: nil)
			//экшен для кнопки презентующий модально NewList
		}
	
	@objc func editTask(notificationEdit: NSNotification) {
		self.editAndSaveTask(withTitle: newCellName)
		print("ko")
		tableView.reloadData()
	}
	
	@objc func addNewTask(notification: NSNotification) {
		self.saveTask(withTitle: textTaskFromTF)
		tableView.reloadData()
	}
	
	func swipesObservers() {
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
		swipeLeft.direction = .left
		self.view.addGestureRecognizer(swipeLeft)
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
	
	
	
	
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true) //Затухание выбора ячейки
		
		let cell = self.tableView.cellForRow(at: indexPath)
		let text: String = cell!.textLabel!.text!
    oldCellName = text
		//goToNewList()
		goToNewListEditing()
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
	

	//MARK: - SETUP
	func setupTable() {
		self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 650), style: .insetGrouped)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: indentifire)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = UIColor(named: "BGColor")
		self.tableView.isScrollEnabled = true // скроллинг
		self.tableView.separatorStyle = .singleLine
		view.addSubview(tableView)
	}
	
	
	func setupButton(){
		self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 50, y: 650, width: 100, height: 50)
		self.buttonNewTask.backgroundColor = UIColor(named: "WhiteBlack")
		self.buttonNewTask.titleLabel?.font = UIFont(name: "Futura", size: 17)
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor (red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
		self.buttonNewTask.layer.cornerRadius = 20
		self.buttonNewTask.addTarget(self, action: #selector(goToNewList), for: .touchUpInside)
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
	
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let editButton = UIContextualAction(style: .normal, title: "") { action, view, completion in }
		editButton.backgroundColor = UIColor.darkGray
		editButton.image = UIImage.init(systemName: "pencil")
		
		let editButton2 = UIContextualAction(style: .normal, title: "") { action, view, completion in }
		editButton2.backgroundColor = UIColor.green
		editButton2.image = UIImage.init(systemName: "star")

				return UISwipeActionsConfiguration(actions: [editButton, editButton2])
	}
	
	
	//NavigationItems
	private func setupNavigationItems(){
		self.title = "Your tasks"
		self.navigationItemImage = "line.horizontal.3.decrease"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationItemImage),
																														style: .plain,
																														target: self,
																														action: #selector(didTapMenu))
	}

	
//	func interactivePopGestureRecognizer(){ //распознователь жестов
//	navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//	}
	
	
	//setupOther
	private func setupOther(){
		self.view.backgroundColor = UIColor(named: "BGColor")
		var tabBarItem = UITabBarItem()
		tabBarItem = UITabBarItem(title: nil,
																		image: UIImage(systemName: "checkmark.seal"),
																		tag: 1)
		self.tabBarItem = tabBarItem
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50.0
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
		let task = tasks[indexPath.row]
		cell.textLabel?.text = task.text
		cell.backgroundColor = UIColor(named: "WhiteBlack")
		return cell
	}
}
