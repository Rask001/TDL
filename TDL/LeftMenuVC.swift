//
//  SettingsVC.swift
//  TDL
//
//  Created by Антон on 22.01.2022.
//
import UIKit
import CoreData
class LeftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	var folders: [Folder] = []
	
  
	let vc = NewListViewController()
	var tableView = UITableView()
	let indentifire = "Cell"
	let buttonNewList = UIButton(type: .system)
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		menuOpen = true
		print("true")
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest() //используем классовый метод
		do{
			folders = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		menuOpen = false
		print("false")
	}
	
	
// MARK: - viewDidLoad
  override func viewDidLoad() {
		super.viewDidLoad()
		setupOther()
		setupTable()
		navigationBarSetup()
		setupButton()
		notification()
		//longPress()
    interactivePopGestureRecognizer()
		//tapObservers()
	}
	
	
	@objc func addNewFolders(notification: NSNotification) {
		self.saveFolders(withTitle: textFromTF)
		tableView.reloadData()
	}
	
	
	func saveFolders(withTitle title: String) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let entity = NSEntityDescription.entity(forEntityName: "Folder", in: context) else {return}
		let folderObject = Folder(entity: entity, insertInto: context)
		folderObject.name = title
		do{
			try context.save()
			folders.append(folderObject)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	func deleteAllFolders(){
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
		if let folders = try? context.fetch(fetchRequest) {
			for folder in folders {
				context.delete(folder)
				self.folders.removeAll(keepingCapacity: false)
			}
		}
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	
	@objc func allertSure() {
		let areYouSureAllert = UIAlertController(title: "Delete all folders", message: nil, preferredStyle: .actionSheet)
		let yesAction = UIAlertAction(title: "Delete", style: .destructive) { [self] action in
			deleteAllFolders()
			tableView.reloadData()
		}
		
		let noAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
		}
		areYouSureAllert.addAction(yesAction)
		areYouSureAllert.addAction(noAction)
		
		present(areYouSureAllert, animated: true)
	}
	

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: indentifire, for: indexPath)
		let folder = folders[indexPath.row]
		cell.textLabel?.text = folder.name
		cell.backgroundColor = UIColor(named: "WhiteBlack")
		return cell
	}
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50.0
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return folders.count
	}
	
	
	// MARK: - SETUP
	private func setupOther() {
		view.backgroundColor = UIColor(named: "WhiteBlack")
	}
	
	
	func navigationBarSetup() {
		let leftButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
																		 style: .plain,
																		 target: self,
																		 action: #selector(allertSure))
		let rightButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
																			style: .plain,
																			target: self,
																			action: #selector(edit))
		self.navigationItem.leftBarButtonItem = leftButton
		self.navigationItem.rightBarButtonItem = rightButton
		self.navigationItem.title = "Folders"
	}
	
	
	func setupTable() {
		self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 314, height: 650), style: .insetGrouped)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: indentifire)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = UIColor(named: "WhiteBlack")
	  self.tableView.isScrollEnabled = false //отключение скроллинга
		self.tableView.separatorStyle = .none
		view.addSubview(tableView)
	}
	
	
	func setupButton(){
		self.buttonNewList.frame = CGRect(x: 82, y: 700, width: 150, height: 50)
		self.buttonNewList.backgroundColor = UIColor(named: "BGColor")
		self.buttonNewList.titleLabel?.font = UIFont(name: "Futura", size: 17)
		self.buttonNewList.setTitle("Create new list", for: .normal)
		self.buttonNewList.setTitleColor(UIColor (red: 50/255, green: 50/255, blue: 50/255, alpha: 1), for: .normal)
		self.buttonNewList.layer.cornerRadius = 10
		self.buttonNewList.addTarget(self, action: #selector(goToNewListViewController), for: .touchUpInside)
		view.addSubview(self.buttonNewList)
	}
	
  
	func notification(){
		NotificationCenter.default.addObserver(self, selector: #selector(addNewFolders), name: Notification.Name("Folder"), object: .none)
		//переносит введеный текст из newListViewController в LeftMenu
	}
	
	
	func longPress(){
	let longpress = UILongPressGestureRecognizer(target: self, action: #selector(edit))
		longpress.minimumPressDuration = 0.4
	tableView.addGestureRecognizer(longpress)
	}
	
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	func interactivePopGestureRecognizer(){ //распознователь жестов
	navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
	
	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let editButton = UIContextualAction(style: .normal, title: "") { action, view, completion in
			print("YO!")
		}
		
		editButton.backgroundColor = UIColor.darkGray
		editButton.image = UIImage.init(systemName: "pencil")
		let editButton2 = UIContextualAction(style: .normal, title: "hey") { action, view, completion in
			print("hey")
		}
		editButton2.backgroundColor = UIColor.green
//		let label = UILabel()
//				label.text = "trtr"
//				label.font = UIFont(name: "America Typewriter", size: 15)
//      	label.sizeToFit(editButton2)
//		editButton2.image = UIImage(view: label)
				return UISwipeActionsConfiguration(actions: [editButton, editButton2])
	}
	
	
	
	

	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let index = indexPath.row
		
		context.delete(folders[index] as NSManagedObject)
		folders.remove(at: index)
		
		let _ : NSError! = nil
		do {
			try context.save()
			self.tableView.reloadData()
		} catch {
			print("error : \(error)")
		}
	}
	
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let item = folders[sourceIndexPath.row] //подняли наш айтем
		folders.remove(at: sourceIndexPath.row) //удалили с того места где он был
		folders.insert(item, at: destinationIndexPath.row) // положили на новое место
	}
	
	
	@objc func tappedMedium() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
	}
	@objc func tappedHeavy() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
	}
	@objc func tappedSoft() {
		let generator = UIImpactFeedbackGenerator(style: .soft)
		generator.impactOccurred()
	}
	@objc func tappedRigid() {
		let generator = UIImpactFeedbackGenerator(style: .rigid)
		generator.impactOccurred()
	}
	
	
	@objc func endEditing(){
		if tableView.isEditing == true {
			tableView.isEditing = false
			tappedSoft()
		}
	}
	
	
	func tapObservers() {
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
		singleTap.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(singleTap)
	}
	
	
	@objc func edit(Recognizer: UIBarButtonItem) {
		tableView.isEditing = !tableView.isEditing
		tappedSoft()
//		if Recognizer.state == .began {
//		tappedHeavy()
//		tableView.isEditing = !tableView.isEditing
//	} else if
//		Recognizer.state == .ended{
		//tappedRigid()
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)//Затухание выбора ячейки
	}
	
	@objc func goToNewListViewController() {
		self.present(vc, animated: true, completion: nil)
		//экшен для кнопки презентующий модально NewListViewController
	}
}
