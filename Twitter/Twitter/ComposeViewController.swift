//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.layer.cornerRadius = 4
            self.profileImageView.clipsToBounds = true
            self.profileImageView.isUserInteractionEnabled = true
        }
    }

    @IBOutlet weak var composeTextView: UITextView!
    
    @IBAction func onClosePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetPressed(_ sender: Any) {
        if let text = self.composeTextView.text {
            TwitterClient.sharedInstance?.sendTweet(text: text, callBack: { (tweet, error) in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView

        self.composeTextView.delegate = self
        self.updateCharacterCount()
        
        self.composeTextView.becomeFirstResponder()
        self.profileImageView.setImageWith((User.currentUser?.profileUrl!)!)
        self.nameLabel.text = User.currentUser?.name
        self.screenNameLabel.text = User.currentUser?.screenname
    }

    func updateCharacterCount() {
        self.charsLeftLabel.text = "\(Int(140-(self.composeTextView.text?.characters.count)!))"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
