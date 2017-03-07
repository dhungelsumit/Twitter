//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/28/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBAction func backButtonPressed(_ sender: Any) {
        print("BACKBUTTON PRESSED")
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.alwaysBounceVertical = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = 4
            self.profileImageView.clipsToBounds = true
            self.profileImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favorButton: UIButton!
    
    
    @IBAction func onReplyButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "toReply", sender: nil)
    }
    
    @IBAction func onRetweetButtonPress(_ sender: Any) {
        print("RETWEET BUTTON PRESSED")
        self.tweet.retweeted = !self.tweet.retweeted;
        TwitterClient.sharedInstance?.toggleRetweet(tweet: self.tweet, create: self.tweet.retweeted, callBack: { (tweetSuccess, tweetError) in
            print("GOT HERE")
            if tweetSuccess != nil {
                print("SUCCESS")
                self.tweet = tweetSuccess
                self.updateRetweetUI()
            }
        })
    }
    
    @IBAction func onFavorButtonPress(_ sender: Any) {
        print("FAVOR BUTTON PRESSED")
        self.tweet.favored = !self.tweet.favored;
        TwitterClient.sharedInstance?.toggleFavorTweet(tweet: self.tweet, create: self.tweet.favored, callBack: { (tweetSuccess, tweetError) in
            print("GOT HERE")
            if tweetSuccess != nil {
                print("SUCCESS")
                self.tweet = tweetSuccess
                self.updateFavoriteUI()
            }
        })
    }
    
    @IBOutlet weak var mediaImageView: UIImageView! {
        didSet {
            self.mediaImageView.layer.cornerRadius = 4
            self.mediaImageView.clipsToBounds = true
            self.mediaImageView.isUserInteractionEnabled = true
        }
    }
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView

        if self.tweet != nil {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var tweetToMediaConstraint: NSLayoutConstraint!
    
    func updateUI() {
        self.nameLabel.text = self.tweet?.user.name
        self.screenNameLabel.text = "@" + (self.tweet?.user.screenname!)!
        self.tweetTextLabel.text = self.tweet.text
        
        self.updateFavoriteUI()
        self.updateRetweetUI()
        
        if let userProfileURL = self.tweet.user.profileUrl {
            self.profileImageView.setImageWith(userProfileURL)
        }
        
        if let photo = self.tweet.photos?.first {
            print("PHOTO IS NOT NIL")
            self.mediaHeightConstraint.constant = self.mediaImageView.frame.size.width * photo.size.height / photo.size.width
            self.mediaImageView.setImageWith(photo.photoURL)
            print("SUCCESSFULLY SET IMAGEVIEW")
        } else {
            print("NO MEDIA FOR THIS TWEET")
            self.tweetToMediaConstraint.constant = 0
            self.mediaHeightConstraint.constant = 0
        }
    }
    
    func updateRetweetUI() {
        print("IS IT RETWEETED? " + String(self.tweet.favored))
        self.retweetsLabel.text = String(self.tweet!.retweetCount)
        if self.tweet.retweeted {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }
    
    func updateFavoriteUI() {
        print("IS IT FAVORED? " + String(self.tweet.favored))
        self.likesLabel.text = String(self.tweet!.favoritesCount)
        if self.tweet.favored {
            self.favorButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            self.favorButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("PREPARE CALLED")
        if segue.identifier == "toReply" {
            let tweetDetailsNC = segue.destination as? UINavigationController
            let tweetVC = tweetDetailsNC?.topViewController as? ReplyViewController
            tweetVC?.tweet = self.tweet
        }
    }
 

}
