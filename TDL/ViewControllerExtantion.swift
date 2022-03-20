//
//  ViewControllerExtantion.swift
//  TDL
//
//  Created by Антон on 20.03.2022.
//

import UIKit
import FSCalendar


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
