//
//  GoogleLogin.swift
//
//
//  Created by Ilesh on 18/09/18.
//  Copyright © 2018 Recritd Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLogin : NSObject,  GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let shared = GoogleLogin()

    typealias complitionHandler = (Bool,[String:Any]?) -> Swift.Void
    private var block : complitionHandler?
    var isViewLoader : UIView?
    
    func loginWithGoogle(vc:UIViewController,compliton:@escaping complitionHandler)  {
        self.block = compliton
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes.append(contentsOf: ["https://www.googleapis.com/auth/calendar","https://www.googleapis.com/auth/calendar.events"])
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let userId = "\(user.userID!)"
            var result : [String:Any] = [:]
            result["idToken"] = "\(user.authentication.idToken!)"
            result["name"] = ""
            result["givenName"] = "\(user.profile.givenName!)"
            result["familyName"] = "\(user.profile.familyName!)"
            result["email"] = "\(user.profile.email!)"
            result["id"] = userId
            Singleton.shared.saveToUserDefaults(value:"\(user!.profile.email!)" , forKey: Global.kLoggedInUserKey.strGEmail)
            Singleton.shared.saveToUserDefaults(value:userId , forKey: Global.kLoggedInUserKey.strGId)
            Singleton.shared.saveToUserDefaults(value:"\(user!.authentication.accessToken!)" , forKey: Global.kLoggedInUserKey.strGAccess_token)
            self.block?(true,result)
        } else {
            self.block?(false,nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.block?(false,nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    //MARK:- GET CALENDER LISTS
    func call_GetGoogleCalendarEventList(vc:UIViewController,successBlock: @escaping (_ arrEvents:[EventModel]) -> Void,failureBlock: @escaping () -> Void){
        let param = ["timeMin":Singleton.shared.dateFormatterForCreateMessage().string(from:Date())]
        WebService.callAPI(GoogleURL.getEvents(param), controller: nil, callSilently: true, successBlock: { (response) in
            if let json = response as? [String: Any] {
                var arrEvents:[EventModel] = []
                if let jsonArr = json["items"] as? [[String:Any]] {
                    for element in jsonArr {
                        if let aEvent = EventModel(dictionary: element as NSDictionary){
                            arrEvents.append(aEvent)
                        }
                    }
                }
                successBlock(arrEvents)
            }else{
                failureBlock()
            }
        }) { (error, isTimeout) in
            print("\(String(describing: error?.localizedDescription))")
            failureBlock()
        }
    }
    
    //ADD
    /*
     var param : [String:Any] = [:]
     param["description"] = ""
     param["location"] = ""
     param["hangoutLink"] = ""
     param["summary"] = ""
     param["start"] = ["date":"2018-12-09"]
     param["end"] = ["date":"2018-12-10"]
     */
    func call_ADD_GoogleCalendarEventList(vc:UIViewController,param:[String:Any],successBlock: @escaping (_ aEvents:EventModel) -> Void,failureBlock: @escaping () -> Void){
        WebService.callAPI(GoogleURLEvent.add(param), controller: nil, callSilently: true, successBlock: { (response) in
            if let json = response as? [String: Any] {
                if let aEvent = EventModel(dictionary: json as NSDictionary){
                    successBlock(aEvent)
                }else{
                    failureBlock()
                }
            }else{
                failureBlock()
            }
        }) { (error, isTimeout) in
            print("\(String(describing: error?.localizedDescription))")
            failureBlock()
        }
    }
    
}

import Foundation
import Alamofire

enum GoogleURL: URLRequestConvertible {
    case getEvents([String:Any])
    case deleteEvent(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getEvents:
                return .get
            case .deleteEvent:
                return .delete
            }
        }
        
        let url: URL = {
            let relativePath: String?
            switch self {
            case .getEvents:
                relativePath = "/calendars/\(kRetriUserData().strGoogleEmail!)/events"
            case .deleteEvent(let eId):
                relativePath = "/calendars/\(kRetriUserData().strGoogleEmail!)/events/\(eId)"
            }
            var url = URL(string: "https://www.googleapis.com/calendar/v3")!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        
        var params: [String: Any] {
            switch self {
            case .getEvents(let params):
                return params
            default :
                return [:]
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("Bearer \(kRetriUserData().strGoogleAccessToken!)" , forHTTPHeaderField: "Authorization")
        let encoding = URLEncoding.default
        return try encoding.encode(urlRequest, with:params)
    }
}

enum GoogleURLEvent: URLRequestConvertible {
    case add([String:Any])
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .add:
                return .post
            }
        }
        
        let url: URL = {
            let relativePath: String?
            switch self {
            case .add:
                relativePath = "/calendars/\(kRetriUserData().strGoogleEmail!)/events"
            }
            var url = URL(string: "https://www.googleapis.com/calendar/v3")!
            if let path = relativePath {
                url = url.appendingPathComponent(path)
            }
            return url
        }()
        
        var params: [String: Any] {
            switch self {
            case .add(let params):
                return params
            default :
                return [:]
            }
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("Bearer \(kRetriUserData().strGoogleAccessToken!)" , forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody   = try JSONSerialization.data(withJSONObject: params)
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with:params)
    }
}
