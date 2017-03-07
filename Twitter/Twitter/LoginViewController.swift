//
//  LoginViewController.swift
//  Twitter
//
//  Created by Sumit Dhungel on 2/20/17.
//  Copyright © 2017 Sumit Dhungel. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import RevealingSplashView


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named:"TwitterLogo1" )!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        revealingSplashView.duration = 0.8
        
        revealingSplashView.iconColor = UIColor.white
        revealingSplashView.useCustomIconColor = false
        //Starts animation
        revealingSplashView.startAnimation(){
        }

    }

    
    //Called when user presses login button
    //After login finishes, performs segue to HomeViewController
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            print("I've logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) in
            print("ERROR: \(error.localizedDescription)")
        })
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
