//
//  SettingsViewController.swift
//  TDL
//
//  Created by Антон on 19.02.2022.
//

import UIKit
var backgroundColorGlobal = UIColor.secondarySystemBackground
class SettingsViewController: UIViewController {
var backgroundColor = UIColor()
	
	let redSlider = UISlider()
	let greenSlider = UISlider()
	let blueSlider = UISlider()
	let button = UIButton()
	let label = UILabel()
	var segmentedControl = UISegmentedControl()
	let cellView = UIView()
	let cellView2 = UIView()
	var red: CGFloat = 0
	var green: CGFloat = 0
	var blue: CGFloat = 0
	
        override func viewDidLoad() {
				super.viewDidLoad()
					self.view.backgroundColor = .white
					redSliderSetup()
					greenSliderSetup()
					blueSliderSetup()
					setupButton()
					setupLabel()
					setupSegmented()
					setupView()
	}
	
	
	func setupView(){
		cellView.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 60)
		cellView.backgroundColor = .white
		cellView.layer.cornerRadius = 10
		self.view.addSubview(cellView)
		
		cellView2.frame = CGRect(x: 10, y: 162, width: self.view.bounds.width - 20, height: 60)
		cellView2.backgroundColor = .white
		cellView2.layer.cornerRadius = 10
		self.view.addSubview(cellView2)
	}
	
	
	func setupSegmented() {
		let items = ["background", "cells"]
		segmentedControl = {
			let segments = UISegmentedControl(items: items)
			return segments
		}()
		segmentedControl.frame = CGRect(x: 50, y: 50, width: 275, height: 30)
		self.view.addSubview(segmentedControl)
		segmentedControl.selectedSegmentIndex = 0
	}
	
	
	func setupLabel(){
		label.frame = CGRect(x: 280, y: 90, width: 80, height: 60)
		label.font = UIFont(name: "Futura", size: 12)
		label.numberOfLines = 3
		//label.adjustsFontSizeToFitWidth = true
		self.view.addSubview(label)
	}
	
	func redSliderSetup(){
		self.redSlider.frame = CGRect(x: 17, y: 450, width: 341, height: 44)
		self.redSlider.thumbTintColor = .red
		self.redSlider.minimumTrackTintColor = .black
		self.redSlider.minimumValue = 0
		self.redSlider.maximumValue = 255
		self.redSlider.value = 255
		//self.redSlider.translatesAutoresizingMaskIntoConstraints = false
		self.redSlider.addTarget(self, action: #selector(updateColor (sender:)), for: .valueChanged)
		view.addSubview(redSlider)
	}
	func greenSliderSetup(){
		self.greenSlider.frame = CGRect(x: 17, y: 500, width: 341, height: 44)
		self.greenSlider.thumbTintColor = .green
		self.greenSlider.minimumTrackTintColor = .black
		self.greenSlider.minimumValue = 0
		self.greenSlider.maximumValue = 255
		self.greenSlider.value = 255
		//self.greenSlider.translatesAutoresizingMaskIntoConstraints = false
		self.greenSlider.addTarget(self, action: #selector(updateColor (sender:)), for: .valueChanged)
		view.addSubview(greenSlider)
	}
	func blueSliderSetup(){
		self.blueSlider.frame = CGRect(x: 17, y: 550, width: 341, height: 44)
		self.blueSlider.thumbTintColor = .blue
		self.blueSlider.minimumTrackTintColor = .black
		self.blueSlider.minimumValue = 0
		self.blueSlider.maximumValue = 255
		self.blueSlider.value = 255
		//self.blueSlider.translatesAutoresizingMaskIntoConstraints = false
		self.blueSlider.addTarget(self, action: #selector(updateColor (sender:)), for: .valueChanged)
		view.addSubview(blueSlider)
	}
	
	func setupButton(){
		button.frame = CGRect(x: self.view.bounds.width/2 - 60, y: 650, width: 120, height: 40)
		button.addTarget(self, action: #selector(setColor), for: .touchUpInside)
		button.backgroundColor = UIColor(named: "BlackWhite")
		button.setTitle("Set color", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.setTitleColor(UIColor(named: "BWTrue"), for: .normal)
		button.layer.cornerRadius = 10
		button.titleLabel?.font = UIFont(name: "Futura", size: 17)
		self.view.addSubview(button)
	}
	
	@objc func setColor(){
		print("покрасил")
	}

	@objc func updateColor(sender: UISlider) {
		red = CGFloat (redSlider.value)/255
		green = CGFloat (greenSlider.value)/255
		blue = CGFloat (blueSlider.value)/255
		backgroundColor = UIColor (red: red, green: green, blue: blue, alpha: 1)
		if segmentedControl.selectedSegmentIndex == 0{
		self.view.backgroundColor = backgroundColor
		}else{
			self.cellView.backgroundColor = backgroundColor
			self.cellView2.backgroundColor = backgroundColor
		}
		if redSlider.value < 50 {
		label.textColor = UIColor(white: 0.8, alpha: 0.5)
		}else{
		label.textColor = UIColor(white: 0.5, alpha: 0.3)
		}
		label.text = "Red:     \(Int(redSlider.value))\nGreen: \(Int(greenSlider.value))\nBlue:    \(Int(blueSlider.value))"
		
			}
	}


