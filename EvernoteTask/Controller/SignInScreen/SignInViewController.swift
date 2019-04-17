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
static var signinClicked = false
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auto login
        if UserDefaults.standard.value(forKey: Constants.FACEBOOK_AUTH_TOKEN) != nil {
            print("User already Logged In therefore segue to home")
            performSegue(withIdentifier: "HomeVC", sender: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func facebookLoginClicked(_ sender: Any) {
     SignInViewController.signinClicked = true
     activityIndicator.startAnimating()
 FaceebookSignIn().initFbLogin(viewController:self,onSignInSuccess:onFacebookLoginSuccess,onSignInError:onFacebookLogiFailure)
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        if SignInViewController.signinClicked {
             activityIndicator.startAnimating()
        }
      
    }
    private func onFacebookLoginSuccess() {
     SignInViewController.signinClicked = false
     activityIndicator.stopAnimating()
     performSegue(withIdentifier: "HomeVC", sender: nil)
    }
    
    private func onFacebookLogiFailure() {
        SignInViewController.signinClicked = false
        activityIndicator.stopAnimating()
    }
}
