//
//  App.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import Foundation
import UIKit

class App {
    static let mainStoryboardName = "Main"
    static let grayColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1)
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboardName, bundle: nil)
    
    class func postStatusBarShouldUpdateNotification(style : UIStatusBarStyle) {
        let userInfo = [Notification.Name("statusBarStyleKey") : style]
        let notification = Notification(name: Notification.Name("StatusBarShouldUpdateNotification"), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
    struct Style{
        static let userProfileAvatarCornerRadius: CGFloat = 4.0
    }
    
}
