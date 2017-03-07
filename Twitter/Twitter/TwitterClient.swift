//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/25/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //Pattern for single client used throughout application
    //Static same as class but u can't create class stored properly
    static let sharedInstance =
        TwitterClient(
            baseURL: URL(string:"https://api.twitter.com")!,
            consumerKey: "WF4nuwq81Hg1Bju34qmM2qvuE",
            consumerSecret: "VsfAUqA97H45IYcinBU82DL0TbkY9RRNDrPRyLFSH6Lmr708li"
        )
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    //Called when user presses login button on LoginViewController
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(
            withPath: "oauth/request_token",
            method: "GET",
            callbackURL: URL(string: "twittr:://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                if let requestToken = requestToken {
                    let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
                    UIApplication.shared.open(url)
                }
            }) { (error: Error?) -> Void in
                print("ERROR")
                self.loginFailure!(error!)
            }
    }
    
    //Called when user presses logout button on HomeViewController
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    //Called after user authorizes his/her Twitter account in the browser
    func handleOpenUrl(url: URL) {
        print("Calling handleOpenUrl")
        let urlArr = String(describing: url).components(separatedBy: "?")
        let query = urlArr[1]
        
        let requestToken = BDBOAuth1Credential(queryString: query)

        //Fetch the access token
        fetchAccessToken(
            withPath: "oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential?) in
                print("I GOT THE ACCESS TOKEN")
                
                self.currentAccount(success: { (user: User) -> () in
                    print("account: \(user)")
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
                })
            },
            failure: { (error: Error?) in
                print("ERROR \(error?.localizedDescription)")
                self.loginFailure?(error!)
            }
        )
    }
    
    //Get information about the current account after getting access token
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
       
        get("1.1/account/verify_credentials.json",
            parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
                print("name: \(user.name)")
                print("screenname: \(user.screenname)")
                print("profile url: \(user.profileUrl)")
                print("description: \(user.tagline)")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("ERROR")
            failure(error)
        })
    }
    
    //Called when HomeViewController loads
    func homeTimeline(callBack: @escaping (_ success: [Tweet]?, _ failure: Error?) -> Void) {
        
        get("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                print("GET homeTimeline() finished!!!")
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                callBack(tweets, nil)
                //print(dictionaries)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            callBack(nil, error)
        })
    }
    
    func sendTweet(text: String, callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            callBack(nil, nil)
            return
        }
        let urlString = "/1.1/statuses/update.json?status=" + encodedText
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(dictionary: tweetDict as NSDictionary)
                //User.currentUser?.timeline?.insert(tweet, at: 0)
                callBack(tweet, nil)
            } else {
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    func toggleFavorTweet(tweet: Tweet, create: Bool,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var favorEndPoint: String
        
        if(create) {
            favorEndPoint = "https://api.twitter.com/1.1/favorites/create.json"
        } else {
            favorEndPoint = "https://api.twitter.com/1.1/favorites/destroy.json"
        }
        
        let param = ["id": String(tweet.id)]
        print(favorEndPoint)
        post(favorEndPoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(dictionary: tweetDict as NSDictionary)
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    
    func toggleRetweet(tweet: Tweet, create: Bool,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var retweetEndPoint: String
        
        if(create) {
            retweetEndPoint = "1.1/statuses/retweet/" + String(tweet.id)
        } else {
            retweetEndPoint = "1.1/statuses/unretweet/" + String(tweet.id)
        }
        retweetEndPoint = retweetEndPoint + ".json"
        
        print(retweetEndPoint)
        post(retweetEndPoint, parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response:Any?) in
                print("SUCCESSSSSS")
                if let tweetDict = response as? [String: Any]{
                    var tweet: Tweet?
                    if(create) {
                        if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any] {
                            tweet = Tweet(dictionary: originalTweetDict as NSDictionary)
                        }
                    } else {
                        tweet = Tweet(dictionary: tweetDict as NSDictionary)
                    }
                    callBack(tweet, nil)
                } else {
                    callBack(nil, nil)
                }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print("FAILUREEEE" + error.localizedDescription)
                callBack(nil, error)
            })
    }
    
    func isFollowingUser(userId: UInt,  callBack: @escaping (_ response: Bool?, _ error: Error? ) -> Void){
        get("1.1/friendships/lookup.json", parameters: ["user_id": userId], progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let friendShipDict = (response as? [[String: Any]])?.first{
                if let connection = friendShipDict["connections"] as? [String]{
                    callBack((connection.index(of: "following") != nil), nil)
                } else {
                    callBack(nil, nil)
                }
            } else {
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }

    func getUserProfileTimeline(userScreenName: String, callBack: @escaping (_ response: [Tweet]?, _ error: Error? ) -> Void){
        
        let param: [String : Any] = ["count": 30, "screen_name": userScreenName]
        
        get("/1.1/statuses/user_timeline.json", parameters: param, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let timelineDict = response as? [[String: Any]]{
                let tweets = timelineDict.map{(element) -> Tweet in
                    return Tweet(dictionary: element as NSDictionary)
                }
                callBack(tweets, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }

}
