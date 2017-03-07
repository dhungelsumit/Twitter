//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/26/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate: class  {
    func profileImageViewTapped(cell: TweetTableViewCell, tweet: Tweet)
}

class TweetTableViewCell: UITableViewCell {

    weak var delegate: TweetTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var mediaImageView: UIImageView! {
        didSet {
            self.mediaImageView.layer.cornerRadius = 4
            self.mediaImageView.clipsToBounds = true
            self.mediaImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 4
            self.userImageView.clipsToBounds = true
            self.userImageView.isUserInteractionEnabled = true
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
            self.userImageView.addGestureRecognizer(userProfileTap)
        }
    }
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton! {
        didSet {
            let retweetTap = UITapGestureRecognizer(target: self, action: #selector(retweetButtonTapped(_ :)))
            self.retweetButton.addGestureRecognizer(retweetTap)
        }
    }
    
    @IBOutlet weak var favorButton: UIButton! {
        didSet {
            let favorTap = UITapGestureRecognizer(target: self, action: #selector(favorButtonTapped(_ :)))
            self.favorButton.addGestureRecognizer(favorTap)
        }
    }
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet! {
        didSet {
            print("Setting tweet values")
            self.nameLabel.text = self.tweet.user.name!
            self.screenNameLabel.text = "@" + self.tweet.user.screenname!
            self.tweetTextLabel.text = self.tweet.text!
            self.createdAtLabel.text = self.tweet.timestampString!
            
            self.userImageView.image = nil
            if let userProfileURL = self.tweet.user.profileUrl {
                self.userImageView.setImageWith(userProfileURL)
            }
            
            self.updateFavorIconUI()
            self.updateRetweetIconUI()
            self.replyButton.setTitle("\(self.tweet.replyCount)", for: .normal)
            
            self.mediaImageView.image = nil
            if let photo = self.tweet.photos?.first {
                self.mediaHeightConstraint.constant = self.mediaImageView.frame.size.width * photo.size.height / photo.size.width
                self.mediaImageView.setImageWith(photo.photoURL)
            } else {
                self.mediaHeightConstraint.constant = 0
            }
            print("done setting tweet values")
        }
    }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer){
        if let delegate = delegate {
            delegate.profileImageViewTapped(cell: self, tweet: self.tweet)
        }
    }
    
    func favorButtonTapped (_ gesture: UITapGestureRecognizer) {
        self.tweet.favored = !self.tweet.favored;
        TwitterClient.sharedInstance?.toggleFavorTweet(tweet: self.tweet, create: self.tweet.favored, callBack: { (tweetSuccess, tweetError) in
            if tweetSuccess != nil {
                print("FAVOR SUCCESS")
                self.tweet = tweetSuccess
                self.updateRetweetIconUI()
            } else {
                print("FAILED TO FAVOR")
            }
        })
        self.updateFavorIconUI()
    }
    
    func retweetButtonTapped (_ gesture: UITapGestureRecognizer) {
        self.tweet.retweeted = !self.tweet.retweeted;
        TwitterClient.sharedInstance?.toggleRetweet(tweet: self.tweet, create: self.tweet.retweeted, callBack: { (tweetSuccess, tweetError) in
            if tweetSuccess != nil {
                print("RETWEET SUCCESS")
                self.tweet = tweetSuccess
                self.updateRetweetIconUI()
            } else {
                print("FAILED TO RETWEET")
            }
        })
    }
    
    func updateFavorIconUI() {
        self.favorButton.setTitle("\(self.tweet.favoritesCount)", for: .normal)
        if self.tweet.favored {
            self.favorButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            self.favorButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
    }
    
    func updateRetweetIconUI() {
        self.retweetButton.setTitle("\(self.tweet.retweetCount)", for: .normal)
        if self.tweet.retweeted {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
