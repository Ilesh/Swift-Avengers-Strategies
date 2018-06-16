//
//  AFAPICaller.swift
//  Created by SAS
//  Copyright © 2018. All rights reserved.


import UIKit
import SpinKit
import Alamofire

class AFAPICaller: NSObject {
    
    typealias AFAPICallerSuccess = (_ responseData: Any, _ success: Bool) -> Void
    typealias AFAPIGoogleSuccess = (_ success: Bool) -> Void
    
    typealias AFAPICallerFailure = () -> Void
    typealias AFAPICallerFailedCall = (_ Error:String, _ Flag:Bool) -> Void
    static let shared = AFAPICaller()
    
    //let afManagerSearch = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
    
    // MARK: -  Add loader in view
    func addShowLoaderInView(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let width : CGFloat = (54 * Global.screenWidth)/320
        let viewSpinnerBg = UIView(frame: CGRect(x: (Global.screenWidth - width) / 2.0, y: (Global.screenHeight - width) / 2.0, width: width, height: width))
        viewSpinnerBg.backgroundColor = #colorLiteral(red: 1, green: 0.7764705882, blue: 0.03921568627, alpha: 1).withAlphaComponent(0.9)  //Global().RGB(r: 240, g: 240, b: 240, a: 0.4)
        viewSpinnerBg.layer.masksToBounds = true
        viewSpinnerBg.layer.cornerRadius = 5.0
        viewObj.addSubview(viewSpinnerBg)
        
        if boolShow {
            viewSpinnerBg.isHidden = false
        }
        else {
            viewSpinnerBg.isHidden = true
        }
        
        if !enableInteraction {
            viewObj.isUserInteractionEnabled = false
        }
        //add spinner in view
        let rtSpinKitspinner: RTSpinKitView = RTSpinKitView(style: RTSpinKitViewStyle.styleArcAlt , color: UIColor.clear)
        rtSpinKitspinner.center = CGPoint(x: (width) / 2.0, y: (width ) / 2.0)
        rtSpinKitspinner.color = #colorLiteral(red: 0.1254901961, green: 0.2431372549, blue: 0.4862745098, alpha: 1)
        rtSpinKitspinner.startAnimating()
        viewSpinnerBg.addSubview(rtSpinKitspinner)
        return viewSpinnerBg
    }
    
    func addShowLoaderInViewSmallLoader(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let viewSpinnerBg = UIView(frame: CGRect(x: (Global.screenWidth - 54.0) / 2.0, y: (Global.screenHeight - 54.0) / 2.0, width: 20.0, height: 20.0))
        viewSpinnerBg.backgroundColor = Global().RGB(r: 240, g: 240, b: 240, a: 4.0)
        viewSpinnerBg.layer.masksToBounds = true
        viewSpinnerBg.layer.cornerRadius = 5.0
        viewObj.addSubview(viewSpinnerBg)
        
        if boolShow {
            viewSpinnerBg.isHidden = false
        }
        else {
            viewSpinnerBg.isHidden = true
        }
        
        if !enableInteraction {
            viewObj.isUserInteractionEnabled = false
        }
        //add spinner in view
        let rtSpinKitspinner: RTSpinKitView = RTSpinKitView(style: RTSpinKitViewStyle.styleArcAlt , color: UIColor.white)
        rtSpinKitspinner.center = CGPoint(x: (viewSpinnerBg.frame.size.width) / 2.0, y: (viewSpinnerBg.frame.size.height ) / 2.0)
        rtSpinKitspinner.color = #colorLiteral(red: 0.2179464698, green: 0.5849778652, blue: 0.8532606959, alpha: 1)
        rtSpinKitspinner.startAnimating()
        viewSpinnerBg.addSubview(rtSpinKitspinner)
        return viewSpinnerBg
    }
    
    /*func callAPIUsingGETGoogleConnection(filePath: String, params: NSMutableDictionary?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPIGoogleSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        let strPath = filePath;
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setAuthorizationHeaderFieldWithUsername("admin", password: "1234")
        afManager.get(strPath, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            onSuccess(true)
        }) { (task: URLSessionDataTask?, error: Error) in
            onFailure()
        }
    }*/
    
    // MARK: -  Hide and remove loader from view
    func hideRemoveLoaderFromView(removableView: UIView, mainView: UIView) {
        removableView.isHidden = true
        removableView.removeFromSuperview()
        mainView.isUserInteractionEnabled = true
    }
    
    // MARK: -  Call web service with GET method
    
    func callAPI_GET(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Global.is_Reachablity().isNetwork else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
            return
        }
        
        
        let strPath = Global.baseURLPath + filePath;
        var viewSpinner: UIView?
        if (showLoader) {
            viewSpinner = self.addShowLoaderInView(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
      
        
        print("URL:- \(strPath) \nPARAM:- \(String(describing: params))")

        var headers : [String:String] = [:]
        if (Global.kretriUserData().IsLoggedIn!.toBool()){
            let token = Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)!
            headers = [
                "Authorization": "\(token)"
            ]
        }
        
        
        
        request(strPath, method: .get, parameters: params, encoding: URLEncoding() as ParameterEncoding,headers: headers).responseJSON { (response:DataResponse<Any>) in
            if (showLoader) {
                self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            if response.result.isSuccess {
                print(response.result.value  as? [AnyObject])
                if let dictResponse = response.result.value  as? [AnyObject] {
                    onSuccess(dictResponse, true)
                }else if let dictResponse = response.result.value  as? [String:Any] {
                    if let msg = dictResponse["status_code"] as? Int, msg == 401 || msg == 500 {
                       self.alertLogout()
                       onFailure()
                    }else{
                        if let str = dictResponse["status"] as? String , str.toBool() {
                            onSuccess(dictResponse, true)
                        }else{
                            if let errorDic = dictResponse["errors"] as? NSDictionary {
                                if let arrMsg = errorDic.allValues as? [String] {
                                    let strMsg = arrMsg.joined(separator: ",")
                                    Singleton.sharedSingleton.showWarningAlert(withMsg: strMsg )
                                }
                                onFailure()
                            }else{
                                Singleton.sharedSingleton.showWarningAlert(withMsg:  dictResponse["msg"] as? String ?? "")
                                onFailure()
                            }
                        }
                    }
                }
            }else{
                print("Error:- \(String(describing: response.result.error?.localizedDescription))")
                if (showLoader) {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                    //Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
                }
                onFailure()
            }
        }
    }
    
    func callAPI_POST(filePath: String,  params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Global.is_Reachablity().isNetwork else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
            return
        }
        
        let strPath = Global.baseURLPath + filePath;
        print("URL:- \(strPath) \nPARAM:- \(String(describing: params))")
        
        var viewSpinner: UIView?
        if (showLoader) {
            viewSpinner = self.addShowLoaderInView(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
       
        var headers : [String:String] = [:]
        if (Global.kretriUserData().IsLoggedIn!.toBool()){
            let token = Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)!
            headers = [
                "Authorization": "\(token)"
            ]
        } else  {
            headers = [
                "Authorization": ""
            ]
        }
        
        request(strPath, method: .post, parameters: params, encoding: URLEncoding() as ParameterEncoding, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response)
            if (showLoader) {
                self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            if response.result.isSuccess {
                if let dictResponse = response.result.value  as? [AnyObject] {
                    onSuccess(dictResponse, true)
                }else if let dictResponse = response.result.value  as? [String:AnyObject] {
                    if let msg = dictResponse["status_code"] as? Int, msg == 401 || msg == 500 {
                        self.alertLogout()
                        onFailure()
                    }else{
                        if let str = dictResponse["status"] as? String , str.toBool() {
                           onSuccess(dictResponse, true)
                        }else{
                            if let errorDic = dictResponse["errors"] as? NSDictionary {
                                if let arrMsg = errorDic.allValues as? [String] {
                                    let strMsg = arrMsg.joined(separator: ",")
                                    Singleton.sharedSingleton.showWarningAlert(withMsg: strMsg )
                                }
                                onFailure()
                            }else{
                                Singleton.sharedSingleton.showWarningAlert(withMsg:  dictResponse["msg"] as? String ?? "")
                                onFailure()
                            }
                        }
                    }
                }
            }else{
                print("Error:- \(String(describing: response.result.error?.localizedDescription))")
                if (showLoader) {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
                onFailure()
            }
        }
    }
    //for Address before login not in used now
    func callAPI_POST_ForWithOutLoginToken(filePath: String,  params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Global.is_Reachablity().isNetwork else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
            return
        }
        
        let strPath = Global.baseURLPath + filePath;
        print("URL:- \(strPath) \nPARAM:- \(String(describing: params))")
        
        var viewSpinner: UIView?
        if (showLoader) {
            viewSpinner = self.addShowLoaderInView(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        
        
        var headers : [String:String] = [:]
        if (Global.kretriUserData().IsLoggedIn!.toBool()){
            let token = Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)!
            headers = [
                "Authorization": "\(token)"
            ]
        }
        request(strPath, method: .post, parameters: params, encoding: URLEncoding() as ParameterEncoding, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response)
            if (showLoader) {
                self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            if response.result.isSuccess {
                if let dictResponse = response.result.value  as? [AnyObject] {
                    onSuccess(dictResponse, true)
                }else if let dictResponse = response.result.value  as? [String:AnyObject] {
                    if let msg = dictResponse["status_code"] as? Int, msg == 401 || msg == 500 {
                        self.alertLogout()
                        onFailure()
                    }else{
                        if let str = dictResponse["status"] as? String , str.toBool() {
                            onSuccess(dictResponse, true)
                        }else{
                            if let errorDic = dictResponse["errors"] as? NSDictionary {
                                if let arrMsg = errorDic.allValues as? [String] {
                                    let strMsg = arrMsg.joined(separator: ",")
                                    Singleton.sharedSingleton.showWarningAlert(withMsg: strMsg )
                                }
                                onFailure()
                            }else{
                                Singleton.sharedSingleton.showWarningAlert(withMsg:  dictResponse["msg"] as? String ?? "")
                                onFailure()
                            }
                        }
                    }
                }
            } else {
                print("Error:- \(String(describing: response.result.error?.localizedDescription))")
                if (showLoader) {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                    //Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
                }
                onFailure()
            }
        }
    }
    
    func call_API_POST_WithOutErrors(filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Global.is_Reachablity().isNetwork else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
            return
        }
        
        
        let strPath = Global.baseURLPath + filePath;
        print("URL:- \(strPath) \nPARAM:- \(String(describing: params))")
        var viewSpinner: UIView?
        if (showLoader) {
            viewSpinner = self.addShowLoaderInView(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        var headers : [String:String] = [:]
        if (Global.kretriUserData().IsLoggedIn!.toBool()){
            let token = Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)!
            headers = [
                "Authorization": "\(token)"
            ]
        }
        request(strPath, method: .post, parameters: params, encoding: URLEncoding() as ParameterEncoding, headers: headers).responseJSON { (response:DataResponse<Any>) in
            print(response)
            if (showLoader) {
                self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
            }
            if response.result.isSuccess {
                if let dictResponse = response.result.value  as? [AnyObject] {
                    onSuccess(dictResponse, true)
                }else if let dictResponse = response.result.value  as? [String:AnyObject] {
                    if let msg = dictResponse["status_code"] as? Int, msg == 401 || msg == 500 {
                        self.alertLogout()
                        onFailure()
                    }else{
                        onSuccess(dictResponse, true)
                    }
                }
            }else{
                print("Error:- \(String(describing: response.result.error?.localizedDescription))")
                if (showLoader) {
                    self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                    //Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
                }
                onFailure()
            }
        }
    }
    
    func callAPI_ImageUpload(filePath: String,image:UIImage?, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, onSuccess: @escaping (AFAPICallerSuccess), onFailure: @escaping (AFAPICallerFailure)) {
        
        guard Global.is_Reachablity().isNetwork else {
            Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
            return
        }
        
        let strPath = Global.baseURLPath + filePath;
        print("URL:- \(strPath) \nPARAM:- \(String(describing: params))")
        var viewSpinner: UIView?
        if (showLoader) {
            viewSpinner = self.addShowLoaderInView(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
        }
        var headers : [String:String] = [:]
        if (Global.kretriUserData().IsLoggedIn!.toBool()){
            let token = Singleton.sharedSingleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)!
            headers = [
                "Authorization": "\(token)"
            ]
        }
        var imgData:Data?
        if image != nil {
            imgData = UIImageJPEGRepresentation(image!, 0.3)
        }else{
            imgData = Data()
        }
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if image != nil {
                multipartFormData.append(imgData!, withName: "profile_image",fileName: "profile_image.png", mimeType: "image/jpg")
            }
            for (key, value) in params! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }}
            ,usingThreshold:UInt64.init(),to:strPath,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { result in
                            switch result {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    if (showLoader) {
                                        self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                                    }
                                    if let dictResponse = response.result.value  as? [AnyObject] {
                                        onSuccess(dictResponse, true)
                                    }else if let dictResponse = response.result.value  as? [String:AnyObject] {
                                        if let msg = dictResponse["status_code"] as? Int, msg == 401 || msg == 500 {
                                            self.alertLogout() //Global.appDelegate.logoutUser()
                                            onFailure()
                                        }else{
                                            print("Response Image \(dictResponse)")
                                            if let str = dictResponse["status"] as? String , str.toBool() {
                                                onSuccess(dictResponse, true)
                                            }else{
                                                if let errorDic = dictResponse["errors"] as? NSDictionary {
                                                    if let arrMsg = errorDic.allValues as? [String] {
                                                        let strMsg = arrMsg.joined(separator: ",")
                                                        Singleton.sharedSingleton.showWarningAlert(withMsg: strMsg )
                                                    }
                                                    onFailure()
                                                }else{
                                                    Singleton.sharedSingleton.showWarningAlert(withMsg:  dictResponse["msg"] as? String ?? "")
                                                    onFailure()
                                                }
                                            }
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                if (showLoader) {
                                    self.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                                    //Singleton.sharedSingleton.showWarningAlert(withMsg: LocalizeHelper.sharedInstance.localizedString(forKey: "ERROR_CALL"))
                                }
                                print("Error:- \(encodingError)")
                                onFailure()
             }
        })
    }
    
    //MARK: FORCE LOGOUT
    func alertLogout()
    {
        DispatchQueue.main.async {
            let alert:UIAlertController=UIAlertController(title: "Warning Alert", message: "It seems you are login with another device. ", preferredStyle: UIAlertControllerStyle.actionSheet)
            let Action = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default){ UIAlertAction in
               //Global.appDelegate.logoutUser()
            }
            // Add the actions
            alert.addAction(Action)            
            Global.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: -  Call web service with multi image
   /* func callAPIWithMultiImage(filePath: String, params: NSMutableDictionary?, images: [UIImage], imageParamNames: [String], enableInteraction: Bool, showLoader: Bool, viewObj: UIView, onSuccess: @escaping (AFAPICallerSuccess), onFailure: (AFAPICallerFailure)) {
        let strPath = Global.baseURLPath + filePath;
        
        let viewSpinner: UIView = self.addShowLoaderInView(viewObj: viewObj, boolShow: showLoader, enableInteraction: enableInteraction)!
        
        let afManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        afManager.requestSerializer.setAuthorizationHeaderFieldWithUsername("admin", password: "1234")
        afManager.post(strPath, parameters: params, constructingBodyWith: { (Data) in
            var i: Int = 0
            for image in images {
                let imageData: Data = UIImagePNGRepresentation(image)!
                Data.appendPart(withFileData: imageData, name: imageParamNames[i], fileName: "photo.png", mimeType: "image/png")
                i = i+1;
            }
        }, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            
            let dictResponse = responseObject as! NSDictionary
            if (dictResponse.object(forKey: "flag") as! Bool == true) { //no error
                onSuccess(dictResponse, true)
            }
            else { //with error
                if (showLoader) {
                    Global.singleton.showWarningAlert(withMsg: dictResponse.object(forKey: "response") as! String)
                }
                onSuccess(dictResponse, false)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            if let response = task?.response as? HTTPURLResponse {
                print(response.statusCode)
                if response.statusCode == 401 {
                    AFAPICaller().callAPIUsingTOKEN_Refresh_POST(enableInteraction: true, showLoader: false, viewObj: nil, onSuccess: { (_, _) in
                        
                    }, onFailure: {
                        
                    })
                }
            }
            self.hideRemoveLoaderFromView(removableView: viewSpinner, mainView: viewObj)
            if (showLoader) {
                Global.singleton.showWarningAlert(withMsg: LocalizeHelper().localizedString(forKey: "keyInternetMsg"))
            }
        }
    }*/
}
