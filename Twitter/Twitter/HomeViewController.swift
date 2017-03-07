//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/26/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var tweets =  [Tweet]()
    
    let reuseIdentifier = "TweetCell"
    let tweetCellNibName = "TweetTableViewCell"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            self.tableView.register(UINib(nibName: tweetCellNibName, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear Called!!!")
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /* let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.red
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
        self.navigationItem.titleView = button */
        
        TwitterClient.sharedInstance?.homeTimeline(
            callBack: { (tweets: [Tweet]?, error: Error?) -> Void in
            if error == nil {
                print("In HomeViewController - ViewDidLoadhomeTimeline()  finished!!!")
                self.tweets = tweets!
                self.tableView.reloadData()
            }
        })
    }
    

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func clickOnButton(button: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("PREPARE CALLED")
        if(segue.identifier == "toTweetDetails") {
            let tweetsNC = segue.destination as! UINavigationController
            let tweetsVC = tweetsNC.topViewController as! TweetDetailViewController
            tweetsVC.tweet = tweets[((sender as? IndexPath)?.row)!]
        } else if (segue.identifier == "toProfile") {
            let profileNC = segue.destination as! UINavigationController
            let profileVC = profileNC.topViewController as! ProfileTableViewController
            profileVC.user = (sender as? Tweet)?.user
        }
    }
}

extension HomeViewController: TweetTableViewCellDelegate {
    func profileImageViewTapped(cell: TweetTableViewCell, tweet: Tweet) {
        performSegue(withIdentifier: "toProfile", sender: tweet)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    //Called when selecting a TweetCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECT CALLED with indexPath - \(indexPath)")
        performSegue(withIdentifier: "toTweetDetails", sender: indexPath)
    }
}

