//
//  UIButtonExtension.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

//For the different types of buttons on the profile page
extension UIButton {
    
    func createFollowingBtn(){
        self.setTitle("Following", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = App.themeColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = App.themeColor.cgColor
    }
    
    func createFollowBtn(){
        self.setTitle("+ Follow", for: .normal)
        self.setTitleColor(App.themeColor, for: .normal)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = App.themeColor.cgColor
    }
    
    func createEditProfieBtn(){
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1).cgColor
    }
    
    func createAccountBtn(){
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1).cgColor
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
