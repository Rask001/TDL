//
//  ViewControllerSetup.swift
//  TDL
//
//  Created by Антон on 20.03.2022.
//


import UIKit
import SideMenu

extension ViewController {
	
	//SideMenu
	func setupSideMenu(){
		let menuWidth: CGFloat = 312
		leftMenuNC = SideMenuNavigationController(rootViewController: LeftMenuVC())
		SideMenuManager.default.leftMenuNavigationController = leftMenuNC
		SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
		leftMenuNC?.presentationStyle = .viewSlideOutMenuIn // стиль открытия меню
		leftMenuNC?.presentingViewControllerUserInteractionEnabled = false //представление ViewController Взаимодействие с пользователем включено
		leftMenuNC?.enableSwipeToDismissGesture = true //можно ли свайпать меню
		
		leftMenuNC?.enableTapToDismissGesture = true
		//leftMenuNC?.blurEffectStyle = .extraLight
		leftMenuNC?.menuWidth = menuWidth
	}
	
	//NavigationItems
	func setupNavigationItems(){
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
	
	func setupButton(){
		self.buttonNewTask.frame = CGRect(x: self.view.bounds.width/2 - 60, y: 670, width: 120, height: 50)
		self.buttonNewTask.backgroundColor = UIColor(named: "BlackWhite")
		self.buttonNewTask.titleLabel?.font = UIFont(name: "Futura", size: 17)
		self.buttonNewTask.setTitle("New task", for: .normal)
		self.buttonNewTask.setTitleColor(UIColor(named: "BWTrue"), for: .normal)
		self.buttonNewTask.layer.cornerRadius = 10
		self.buttonNewTask.addTarget(self, action: #selector(goToNewList), for: .touchUpInside)
		//self.buttonNewTask.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
		tableView.addSubview(buttonNewTask)
	}
	
	//setupOther
	func setupOther(){
		self.view.backgroundColor = UIColor(named: "BGColor")
		let tabBarItem = UITabBarItem(title: nil,
																	image: UIImage(systemName: "checkmark.seal")?.withAlignmentRectInsets(.init(top: 10, left: 0, bottom: 0, right: 0)),
																	tag: 0)
		self.tabBarItem = tabBarItem
		
	
		
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
	
	
	
	
}
