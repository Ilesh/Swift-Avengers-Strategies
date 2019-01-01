//
//  FacebookLogin.swift
//
//
//  Created by Ilesh on 18/09/18.
//  Copyright © 2018 Recritd Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit



class FacebookLogin: NSObject {
    
    typealias complitionHandler = (FBSDKGraphRequestConnection?, Any?, Error?) -> Swift.Void
    typealias complitionHandler1 = (Dictionary<String,String>?, String?) -> Swift.Void
    typealias complitionHandlerFBFriendsFetch = ([String:Any]?,String?) -> Void
    var isViewLoader : UIView?
    
    static func loginWithFB(vc:UIViewController,compliton:@escaping complitionHandler1)  {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: vc) { (result, error) -> Void in
            
            //isViewLoader = AFAPICaller.shared.addShowLoaderInView(viewObj: vc.view, boolShow: true, enableInteraction: true)
            if (error == nil){
                if (result?.token != nil){
                    
                    FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                        
                        //SVProgressHUD.dismiss()
                        if (error != nil) {
                            compliton(nil,error?.localizedDescription)
                        }
                        else
                        {
                            var aDicFBData: [String: String] = [:]
                            
                            let resultData = result as! Dictionary<String, Any>
                            
                            if let aStrEmail =  resultData["email"] as? String {
                                aDicFBData["email"] = aStrEmail
                            }
                            let aStrId:String = resultData["id"] as? String ?? ""
                            aDicFBData["id"] = aStrId
                            
                            let aStrFirstName:String = resultData["first_name"] as? String ?? ""
                            aDicFBData["firstName"] = aStrFirstName
                            
                            let aStrLastName:String = resultData["last_name"] as? String ?? ""
                            aDicFBData["lastName"] = aStrLastName
                            
                            let aUSerName:String = resultData["name"] as? String ?? ""
                            aDicFBData["userName"] = aUSerName
                            
                            if let picture = resultData["picture"] as? Dictionary<String, Any> {
                                if let data = picture["data"] as? Dictionary<String, Any> {
                                    aDicFBData["imgUrl"] = data["url"] as? String ?? ""
                                }
                            }
                            
                            compliton(aDicFBData,nil)
                        }
                    })
                }
                else {
                    //SVProgressHUD.dismiss()
                    compliton(nil,"Login Failed")
                }
            }
            else
            {
                //SVProgressHUD.dismiss()
                compliton(nil,error?.localizedDescription)
            }
        }
    }
    
    static func loginWithFBPublishPermissions(vc:UIViewController,compliton:@escaping complitionHandler1)  {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withPublishPermissions: ["publish_actions"], from: vc, handler: {(result, error) -> Void in
            if (error == nil){
                if (result?.token != nil){
                    var aDicFBData: [String: String] = [:]
                    aDicFBData["token"] = result?.token.tokenString
                    compliton(aDicFBData, nil)
                }
                else
                {
                    compliton(nil,"Login fails")
                }
            }
            else
            {
                compliton(nil,error?.localizedDescription)
            }
        })
        
    }
}
