//
//  TableViewCell.swift
//  TDL
//
//  Created by Антон on 10.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	let backgroundViewCell: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 10
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let taskText: UILabel = {
		let label = UILabel()
		label.textColor = .darkGray
		label.font = UIFont(name: "Avenir Next", size: 16)
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = true
		label.translatesAutoresizingMaskIntoConstraints = false
		//label.backgroundColor = .lightGray
		return label
	}()
	
	private let alarmImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "alarm")
		imageView.frame = CGRect(x: 280, y: 5, width: 12, height: 12)
		imageView.tintColor = .gray
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	//318 38
	private let repeatImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "repeat")
		imageView.frame = CGRect(x: 265, y: 5, width: 13, height: 13)
		imageView.tintColor = .gray
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
//	let alarmPicture : UIImage = UIImage(systemName: "Alarm")!
//
	
	override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setConstraints()
		self.selectionStyle = .none
		self.backgroundColor = .clear
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setConstraints() {
		self.backgroundViewCell.addSubview(taskText)
		NSLayoutConstraint.activate([
			taskText.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1),
			taskText.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3),
			taskText.widthAnchor.constraint(equalToConstant: self.frame.width/6),
		])
		self.backgroundViewCell.addSubview(alarmImageView)
		NSLayoutConstraint.activate([
//			alarmImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 3),
//			alarmImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),
//    	alarmImageView.widthAnchor.constraint(equalToConstant: self.frame.width/12),
//	   	alarmImageView.heightAnchor.constraint(equalToConstant: self.frame.width/12),
		])
		self.backgroundViewCell.addSubview(repeatImageView)
		NSLayoutConstraint.activate([
//			repeatImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 3),
//			repeatImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),
//			repeatImageView.widthAnchor.constraint(equalToConstant: self.frame.width/12),
//			repeatImageView.heightAnchor.constraint(equalToConstant: self.frame.width/12),
		])
		
		self.addSubview(backgroundViewCell)
		NSLayoutConstraint.activate([
			backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
			backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
			backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
		])
	}
}

