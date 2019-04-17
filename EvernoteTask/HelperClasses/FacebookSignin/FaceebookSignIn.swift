//
//  FaceebookSignIn.swift
//  EvernoteTask
//
//  Created by Auxenta on 11/27/18.
//  Copyright © 2018 Auxenta. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FaceebookSignIn: NSObject,FBSDKLoginButtonDelegate {
    private var onSignInSuccess: (()->Void )? = nil
    private var onSignInError: (()->Void )? = nil
    
   //Delegate methods
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logged out from facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error.localizedDescription)
        }
        print("Logged successfully to facebook")
        
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    public func initFbLogin(viewController:UIViewController, onSignInSuccess:@escaping ()->Void, onSignInError:@escaping ()->Void){ 
    self.onSignInSuccess = onSignInSuccess
    self.onSignInError = onSignInError
        if UserDefaults.standard.value(forKey: Constants.FACEBOOK_AUTH_TOKEN) != nil {
            print("User already Logged in ")
        }else{
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: viewController) { (result, error) -> Void in
                if (error == nil){
                
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if (result?.isCancelled)! {
                         self.onSignInError?()
                        return
                    }
                    if fbloginresult.grantedPermissions.contains("email")
                    {
                        self.getFBUserData()
                        print("FBLogin sucess")
                        
                    }else {
                        self.onSignInError?()
                        print("FBLogin fail")
                    }
                }else {
                    self.onSignInError?()
                    print("Login fail")
                    print(error!.localizedDescription)
                }
            }
        }
    }
    private func getFBUserData(){
        // print("Token:",FBSDKAccessToken.current())
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    // print("Results:",result!)
                    
                    let data = result as! NSDictionary
                    let email = data ["email"] as! String
                    let name = data ["first_name"] as! String
                    let lastName = data ["last_name"] as! String
                    UserDefaults.standard.set(email, forKey: Constants.FACEBOOK_EMAIL)
                    UserDefaults.standard.set("\(name) \(lastName)", forKey: Constants.FACEBOOK_USERNAME)
                    UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey:  Constants.FACEBOOK_AUTH_TOKEN)
                    UserDefaults.standard.synchronize()
                      self.onSignInSuccess?()
                }
            })
        }
    }

}
