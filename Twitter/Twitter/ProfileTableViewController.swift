//
//  ProfileTableViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var user : User! = User.currentUser
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = 6.0
            self.profileImageView.layer.borderWidth = 4.0
            self.profileImageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var profileButton: UIButton! {
        didSet {
            if self.user.screenname == User.currentUser?.screenname {
                self.profileButton.createEditProfieBtn()
                self.profileButton.setTitle("Edit Profile", for: .normal)
            } else {
                TwitterClient.sharedInstance?.isFollowingUser(userId: self.user!.id!,  callBack: { (isFollowing, error) in
                    if let isFollowing = isFollowing {
                        if isFollowing {
                            self.profileButton.createFollowingBtn()
                            self.profileButton.setTitle("Following", for: .normal)
                        } else {
                            self.profileButton.createFollowBtn()
                            self.profileButton.setTitle("+Follow", for: .normal)
                        }
                    }
                })
            }
        }
    }
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    var tweets: [Tweet]?{
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets![indexPath.row]
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView

        let nib = UINib(nibName: "TweetTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TweetCell")
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if self.user == nil {
            self.user = User.currentUser
        }
        
        if let bannerURL = self.user.profileBannerUrl {
            self.bannerImageView.setImageWith(bannerURL)
            self.view.sendSubview(toBack: self.bannerImageView)
        }
        if let profileImageURL = self.user.profileUrl {
            self.profileImageView.setImageWith(profileImageURL)
        }
        self.nameLabel.text = self.user.name
        self.screenNameLabel.text = "@" + self.user.screenname!
      //  self.taglineLabel.text = self.user.tagline
        self.numFollowersLabel.text = self.user.followerCountStr
        self.numFollowingLabel.text = self.user.followingCountStr
        
        self.loadData(completion: nil)
    }

    func loadData(completion completionHandler:  ((Void) -> Void)? ) {
        guard (self.user) != nil else{
            return
        }
        TwitterClient.sharedInstance?.getUserProfileTimeline(userScreenName: self.user.screenname!) { (tweets, error) in
                if let tweets = tweets {
                    self.tweets = tweets
                    if let completion = completionHandler {
                        completion()
                    }
                }
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
        if segue.identifier == "toCompose" {
            print("GOING TO COMPOSE")
        }
    }

}
