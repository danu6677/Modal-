//
//  SignInViewController.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class SignInViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: Constants.FACEBOOK_AUTH_TOKEN) != nil {
            print("User already Logged in therefore segue")
            performSegue(withIdentifier: "HomeVC", sender: nil)
        }
    }
    
    @IBAction func facebookLoginClicked(_ sender: Any) {
    activityIndicator.startAnimating()
 FaceebookSignIn().initFbLogin(viewController:self,onSignInSuccess:onFacebookLoginSuccess,onSignInError:onFacebookLogiFailure)
        
    }
    override func viewWillAppear(_ animated: Bool) {
      //  print( UserDefaults.standard.value(forKey: Constants.FACEBOOK_LOGOUT)) fix this issue
        if UserDefaults.standard.value(forKey: Constants.FACEBOOK_LOGOUT) != nil {
             activityIndicator.stopAnimating()
        }
    }
    private func onFacebookLoginSuccess() {
     performSegue(withIdentifier: "HomeVC", sender: nil)
    }
    
    private func onFacebookLogiFailure() {
        activityIndicator.stopAnimating()
       
    }
}
