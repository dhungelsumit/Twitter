//
//  User.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/25/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

// Model:
// - Takes care of deserialization and serialization of data
// - Takes care of persistence
// - Echos/captures datatypes of server
class User: NSObject {

    static let userDidLogoutNotification = "UserDidLogout"

    let currentUserKey = "currentUser"
    
    //Stored properties
    var name: String?
    var id: UInt?
    var screenname: String?
    var tagline: String?
    var profileUrl: URL?
    var profileBannerUrl: URL?
    var userDict: NSDictionary?
    
    var followerCountStr: String {
        return Utility.stringifyCount(count: followerCount)
    }
    
    var followingCountStr: String {
        return Utility.stringifyCount(count: followingCount)
    }

    var followerCount: UInt32 {
        return self.userDict!["followers_count"] as! UInt32
    }
    
    var followingCount: UInt32 {
        return self.userDict!["friends_count"] as! UInt32
    }
    
    init(dictionary: NSDictionary) {
        self.userDict = dictionary
        
        //Deserialization code 
        //(takes dictionary and selectively populates individual props based on it)
        self.name = dictionary["name"] as? String //Attempt to cast to String
        self.id = dictionary["id"] as? UInt
        self.screenname = dictionary["screen_name"] as? String
        self.tagline = dictionary["description"] as? String

        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            self.profileUrl = URL(string: profileURLString)
        }
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        if let profileBannerUrlString = profileBannerUrlString {
            self.profileBannerUrl = URL(string: profileBannerUrlString)
        }
        
    }
    
    static var _currentUser: User?
    
    //NSUserDefault - persisted key-value store (like cookies for iOS)
    //Computed property (no storage associated with var)
    class var currentUser: User? {
        //code that runs when someone accesses the property
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: "currentUserData") as? Data {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        return nil
                    }
                }
            }
            return _currentUser
        }
        //set current user (store in UserDefaults)
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.userDict!, options: [])
                print("Set currentUserData to data!!!")
                defaults.set(data, forKey: "currentUserData")
            } else {
                print("Set currentUserData to nil!!!")
                defaults.set(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }

}
