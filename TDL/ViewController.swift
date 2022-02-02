//
//  ViewController.swift
//  TDL
//
//  Created by Антон on 23.01.2022.
//
import SideMenu
import UIKit

var menuOpen = false

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	var tasks: [Tasks] = []
	
	var leftMenuNC: SideMenuNavigationController?
	var tableView = UITableView()
	let indentifire = "Cell"
	
	//MARK: - viewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		setupSideMenu()
	  changeItemImage()
  	setupNavigationItems()
		setupOther()
		swipesObservers()
		tapObservers()
	}
	
	func setupTable() {
		self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 650), style: .plain)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: indentifire)
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.backgroundColor = UIColor(named: "WhiteBlack")
		self.tableView.isScrollEnabled = false //отключение скроллинга
		self.tableView.separatorStyle = .none
		view.addSubview(tableView)
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
	

	//MARK: - SETUP
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
		let 🐏 = "Your tasks"
		self.title = 🐏
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationItemImage),
																														style: .plain,
																														target: self,
																														action: #selector(didTapMenu))
	}
	var navigationItemImage: String = ""
	func changeItemImage() {
	if menuOpen == false {
navigationItemImage = "line.horizontal.3.decrease"
	} else {
		navigationItemImage = "arrowshape.turn.up.right"
	}
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
		<#code#>
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		<#code#>
	}
}
