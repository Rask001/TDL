//
//  TableViewCell.swift
//  TDL
//
//  Created by Антон on 10.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	let taskText: UILabel = {
		let label = UILabel()
		label.text = "04:20"
		label.textColor = .black
		label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .lightGray
		return label
	}()

	
	let alarmPicture: UILabel = {
		var label = UILabel()
		//label.text = UIImage(systemName: "Alarm")
		label.textColor = .black
		label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		label.translatesAutoresizingMaskIntoConstraints = false
		label.backgroundColor = .lightGray
		return label
	}()
	override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setConstraints()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setConstraints() {
		self.addSubview(taskText)
		
		NSLayoutConstraint.activate([
			taskText.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
			taskText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
			taskText.widthAnchor.constraint(equalToConstant: self.frame.width/6),
		])
		
		NSLayoutConstraint.activate([
			taskText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
			taskText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
			taskText.widthAnchor.constraint(equalToConstant: self.frame.width/12),
		])
	}
}

