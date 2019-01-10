//
//  GoogleLogin.swift
//  Recruitd
//
//  Created by macmini on 31/12/18.
//  Copyright © 2018 Recritd Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLogin : NSObject,  GIDSignInDelegate, GIDSignInUIDelegate {
    
    static let shared = GoogleLogin()
    
    typealias complitionHandler = (Bool,[String:Any]?) -> Swift.Void
    private var block : complitionHandler?
    var isViewLoader : UIView?
    
    //MARK:- GOOGLE LOGIN METHODS
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
            result["givenName"] = "\(user.profile.givenName!)"
            result["familyName"] = "\(user.profile.familyName!)"
            result["email"] = "\(user.profile.email!)"
            result["id"] = userId
            result["access_token"] = "\(user!.authentication.accessToken!)"
            Singleton.shared.saveToUserDefaults(value:"\(user.profile.givenName!)" , forKey: Global.kLoggedInUserKey.strGoogleProfileName)
            Singleton.shared.saveToUserDefaults(value:"\(user!.profile.email!)" , forKey: Global.kLoggedInUserKey.strGEmail)
            Singleton.shared.saveToUserDefaults(value:userId , forKey: Global.kLoggedInUserKey.strGId)
            Singleton.shared.saveToUserDefaults(value:"\(user!.authentication.accessToken!)" , forKey: Global.kLoggedInUserKey.strGAccess_token)
            Singleton.shared.saveToUserDefaults(value:user!.authentication.accessTokenExpirationDate , forKey: Global.kLoggedInUserKey.strGAccess_token_exp_date)
            self.block?(true,result)
        } else {
            self.block?(false,["error":error.localizedDescription])
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.block?(false,nil)
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    //MARK:- REFRESH TOKEN METHODS
    func ischeckTokenIsValid() -> Bool? {
        if let dateExprire = Singleton.shared.retriveObjectFromUserDefaults(key: Global.kLoggedInUserKey.strGAccess_token_exp_date) as? Date{
            return Date().isBeforeTime(dateExprire)
        }else{
            return nil
        }
    }
    
    func refreshTokenIfNeed(vc:UIViewController,compliton:@escaping complitionHandler)  {
        if let istoken = self.ischeckTokenIsValid() {
            if istoken { /// TOKEN IS VALID
                compliton(true,[:]) // PARAM NO NEED
            }else{
                self.block = compliton
                self.RefreshToken()
            }
        }else{
            print("Need to google login")
            compliton(false,["error":"Need to google login"])
        }
    }
    
    func RefreshToken(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes.append(contentsOf: ["https://www.googleapis.com/auth/calendar","https://www.googleapis.com/auth/calendar.events"])
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    //MARK:- GET CALENDER LISTS
    func call_GetGoogleCalendarEventList(vc:UIViewController,successBlock: @escaping (_ arrEvents:[EventModel]) -> Void,failureBlock: @escaping () -> Void){
        let param = ["timeMin":Singleton.shared.dateFormatterForCreateMessage().string(from:Date())]
        WebService.callWithoutSessionAPI(GoogleURL.getEvents(param), controller: nil, callSilently: true, successBlock: { (response) in
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
        WebService.callWithoutSessionAPI(GoogleURLEvent.add(param), controller: nil, callSilently: true, successBlock: { (response) in
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
    
    func Call_add_MultipleDates(vc:UIViewController,arrDates: [Date], param: [String:Any],successBlock: @escaping (_ aEvents:[EventModel]) -> Void,failureBlock: @escaping () -> Void) {
        var aEventsResults : [EventModel] = []
        var dicTemp = param
        var arrTempDates = arrDates
        if arrTempDates.count > 0 {
            let date = arrTempDates.first!
            dicTemp["start"] = ["dateTime":Singleton.shared.dateFormatterForApplicantYYYYMMDD().string(from: date)]
            dicTemp["end"] = ["dateTime":Singleton.shared.dateFormatterForApplicantYYYYMMDD().string(from: date.add(minutes: 60))]
            self.call_ADD_GoogleCalendarEventList(vc: vc, param: dicTemp, successBlock: { (event) in
                aEventsResults.append(event)
                successBlock(aEventsResults)
            }) {
                print("Faild events")
                failureBlock()
            }
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
                relativePath = "/calendars/\(kRetriUserData().strGoogleEmail!)/events?sendNotifications=true"
            }
            var url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/\(kRetriUserData().strGoogleEmail!)/events?sendNotifications=true")!
            if let path = relativePath {
                //url = url.appendingPathComponent(path)
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
        //let encoding = JSONEncoding.default
        return try urlRequest
        //return try encoding.encode(urlRequest, with:nil)
    }
}

