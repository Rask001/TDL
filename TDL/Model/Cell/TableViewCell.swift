//
//  TableViewCell.swift
//  TDL
//
//  Created by Антон on 10.02.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	var dateDate = Date()

	
	let backgroundViewCell: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 10
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let taskTitle: UILabel = {
		let labelTitle = UILabel()
		labelTitle.textColor = .black
		labelTitle.font = UIFont(name: "Avenir Next", size: 20)
		labelTitle.textAlignment = .left
		labelTitle.adjustsFontSizeToFitWidth = true
		labelTitle.translatesAutoresizingMaskIntoConstraints = false
		//label.backgroundColor = .lightGray
		return labelTitle
	}()
	
	let buttonCell: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "checkmark"), for: .normal)
		button.frame = CGRect(x:0, y:0, width: 50, height: 50)
		return button
	}()
	
	let taskTime: UILabel = {
		let label = UILabel()
		label.textColor = .darkGray
		label.font = UIFont(name: "Avenir Next", size: 16)
		label.textAlignment = .right
		label.adjustsFontSizeToFitWidth = false //уменьшает шрифт при заполнении строки
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
		self.backgroundViewCell.addSubview(taskTime)
		NSLayoutConstraint.activate([
			taskTime.topAnchor.constraint(equalTo: self.backgroundViewCell.topAnchor, constant: 1),
			taskTime.trailingAnchor.constraint(equalTo: self.backgroundViewCell.trailingAnchor, constant: -3),
			taskTime.widthAnchor.constraint(equalToConstant: self.frame.width/6),
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
		self.backgroundViewCell.addSubview(buttonCell)
		NSLayoutConstraint.activate([
			buttonCell.centerYAnchor.constraint(equalTo: self.backgroundViewCell.centerYAnchor),
			buttonCell.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 0),
//			buttonCell.widthAnchor.constraint(equalToConstant: self.backgroundViewCell.frame.width/12),
//			buttonCell.heightAnchor.constraint(equalToConstant: self.backgroundViewCell.frame.width/12),
		])
		self.addSubview(backgroundViewCell)
		NSLayoutConstraint.activate([
			backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
			backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
			backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
		])
		
		self.backgroundViewCell.addSubview(taskTitle)
		NSLayoutConstraint.activate([
			taskTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			taskTitle.leadingAnchor.constraint(equalTo: self.backgroundViewCell.leadingAnchor, constant: 35),
			taskTitle.trailingAnchor.constraint(equalTo: self.repeatImageView.leadingAnchor, constant: -3)
		])
	}
}

