//
//  Utility.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class Utility: NSObject {
    class func stringifyCount(count: UInt32) -> String{
        if count >= 1000000 {
            var mod = Int(count / 1000000)
            if mod == 0 {
                mod = 1
            }
            return String(mod) + "M"
        } else if count >= 1000 {
            var mod = Int(count / 1000)
            if mod == 0 {
                mod = 1
            }
            return String(mod) + "K"
        } else {
            return String(count)
        }
    }
}
