//
//  TweetPhoto.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/26/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class TweetPhoto: NSObject {
    var size: CGSize!
    var photoURL: URL!
    init(photoDict: [String: Any]){
        if let sizeArrayDict = photoDict["sizes"] as? [String: Any] {
            if let mediumSizeDict = sizeArrayDict["medium"] as? [String: Any] {
                if let width = mediumSizeDict["w"] as? Int, let height = mediumSizeDict["h"] as? Int {
                    self.size = CGSize(width: width, height: height)
                }
            }
        }
        if let urlString = photoDict["media_url_https"] as? String {
            self.photoURL = URL(string: urlString)
        }
    }
}
