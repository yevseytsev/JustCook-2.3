//
//  EZHFacebookLoginButton.swift
//  CookBookSharer
//
//  Created by lei zhang on 2016-12-23.
//  Copyright © 2016 lei zhang. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

protocol FBLoginDelegate {
    func loginWith(_ username:String);
    func logout();
}

class EZHFacebookLoginButton: FBSDKLoginButton, FBSDKLoginButtonDelegate {
    
    fileprivate let userDefault = UserDefaults.standard
    
    public var LGdelegate: FBLoginDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.readPermissions = ["public_profile"]
        
        self.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard error == nil else {
            print("Login Error: \(error)" )
            return
        }
        
        if let token = FBSDKAccessToken.current()  {
            
            if let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, id"], tokenString: token.tokenString, version: nil, httpMethod: "GET") {
                
                req.start(){ (conn, result, err) in
                    if ((err) != nil)
                    {
                        print("Error: \(err)")
                    }
                    else
                    {
                        let data:[String:AnyObject] = result as! [String : AnyObject]
                        
                        self.userDefault.set(data["name"], forKey: Constants.FACEBOOK_USERNAME)
                        self.userDefault.set(data["id"], forKey: Constants.FACEBOOK_ID)
                        
                        self.userDefault.synchronize()
                        print(self.userDefault.string(forKey: Constants.FACEBOOK_ID) ?? "No em")
                        
                        
                        
                        DispatchQueue.main.async {
                            self.LGdelegate.loginWith(data["name"] as! String)
                        }
                    }
                }
            }
        }
        else {
            userDefault.removeObject(forKey: Constants.FACEBOOK_ID)
            userDefault.removeObject(forKey: Constants.FACEBOOK_USERNAME)
            userDefault.synchronize()
        }
        
        
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        userDefault.removeObject(forKey: Constants.FACEBOOK_ID)
        userDefault.removeObject(forKey: Constants.FACEBOOK_USERNAME)
        userDefault.synchronize()
        DispatchQueue.main.async {
            self.LGdelegate.logout()
        }
    }
}
