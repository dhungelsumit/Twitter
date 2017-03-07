//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 3/5/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    var tweet: Tweet?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.cornerRadius = 4.0
            self.profileImageView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var replyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replyTextView.delegate = self
        self.updateCharacterCount()
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterLogoBlue"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView

        self.replyTextView.becomeFirstResponder()
        self.profileImageView.setImageWith((User.currentUser?.profileUrl!)!)
        self.nameLabel.text = User.currentUser?.name
        self.screenNameLabel.text = User.currentUser?.screenname
        self.replyTextView.text = "@" + (tweet?.user.screenname!)!
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateCharacterCount() {
        self.charsLeftLabel.text = "\(Int(140-(self.replyTextView.text?.characters.count)!))"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    //func textView(textView: UITextView, shouldChange)


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
