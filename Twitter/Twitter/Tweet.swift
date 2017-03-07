//
//  Tweet.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/25/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit
import Foundation

class Tweet: NSObject {
    
    static var currentTweets = [Tweet]()
    
    let tweetDict: NSDictionary?

    var text: String?
    var timestamp: Date?
    var timestampString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var replyCount: Int = 0
    var mediaUrl: URL?
    var mediaSize: NSDictionary?
    var retweeted: Bool = false
    var favored: Bool = false
    
    var id: Int64 {
        return self.tweetDict!["id"] as! Int64
    }
    
    //Nested Dictionaries...
    var entitiesDict: [String: Any]? {
        return self.tweetDict?["entities"] as? [String: Any]
    }
    
    var mediaArray: [[String: Any]]? {
        return self.entitiesDict?["media"] as? [[String: Any]]
    }
    
    var photos: [TweetPhoto]? {
        guard let media = mediaArray else {
            return nil
        }
        var res = [TweetPhoto]()
        for m in media {
            res.append(TweetPhoto(photoDict: m))
        }
        return res
    }

    
    init(dictionary: NSDictionary) {
        self.tweetDict = dictionary
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        self.replyCount = (dictionary["listed_count"] as? Int) ?? 0
        self.retweeted = dictionary["retweeted"] as! Bool
        self.favored = dictionary["favorited"] as! Bool
        
        if let entities = dictionary["entities"] as? NSDictionary {
            if let media = entities["media"] as? NSDictionary {
                print("Retrieved media from entities!!!!")
                if let mediaUrlString = media["media_url_https"] as? String {
                    print("Retrieved mediaUrlString from media!!!!")
                    self.mediaUrl = URL(string: mediaUrlString)
                }
                if let sizes = media["sizes"] as? NSDictionary {
                    print("Retrieved sizes from media!!!!")
                    self.mediaSize = sizes["small"] as? NSDictionary
                }
            }
        }
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            self.timestamp = formatter.date(from: timestampString)
            self.timestampString = Tweet.getDisplayDate(fromDate: timestamp!)
        }
    }
    
    var user: User {
        return User(dictionary: tweetDict!["user"] as! NSDictionary)
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        self.currentTweets = tweets
        return tweets
    }
    
    class func getDisplayDate(fromDate date: Date) -> String {
        let elapsedTimeSeconds = Int(-date.timeIntervalSinceNow)
        var output: String = ""
        if elapsedTimeSeconds < 15{
            output = "now"
        }else if elapsedTimeSeconds < 60{
            output = "\(elapsedTimeSeconds)s"
        }else if elapsedTimeSeconds < 60 * 60{
            output = "\(elapsedTimeSeconds / 60)m"
        }else if elapsedTimeSeconds < 60  * 60 * 24{
            output = "\(elapsedTimeSeconds / 3600)h"
        }else if elapsedTimeSeconds < 60 * 60 * 24 * 7{
            output = "\(elapsedTimeSeconds / (3600 * 24))d"
        }else{
            output = "\(elapsedTimeSeconds / (3600 * 24 * 7))w"
        }
        return output;
    }
}
