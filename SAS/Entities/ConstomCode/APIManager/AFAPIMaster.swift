//
//  AFAPIMaster.swift

//
//  Created by SAS 
//  Copyright © 2017 Ilesh. All rights reserved.
//  Ilesh 

import UIKit

class AFAPIMaster: AFAPICaller {
    static let sharedAPIMaster = AFAPIMaster()
    
    typealias AFAPIMasterSuccess = (_ returnData: Any) -> Void
    typealias AFAPIMasterFailure = () -> Void
    
    // MARK: -  Get Application Current Version API
    /*func getAppCurrentVersionData_Completion(params: NSMutableDictionary?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
     self.callAPIUsingGET(filePath: "apiVersionNew?", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict: Any, success: Bool) in
     if (success) {
     onSuccess(responseDict)
     }
     }, onFailure: { () in
     })
     }*/
    
    
    // MARK:-  LOGIN SCREEN
    func postLoginCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "driver/do_login", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
        
    }
    
    // MARK:-  FORGOT SCREEN
    func postForgotPwdWithMobileCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "secure/do_forgot_password", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
    
    // MARK:-  LOGIN SCREEN
    func postSignUpWithEmailCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "secure/do_register", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
        
    }
    
    func postSocial_LoginRegistration_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.call_API_POST_WithOutErrors(filePath: "secure/do_social_register", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
        
    }
    
    //MARK:- MY ADDRESS
    func postADDLocationCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "rest_api/add_edit_address", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
        
    }
    
    func post_DELETE_LocationCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "rest_api/delete_address", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
        
    }
    
    func postNotifyMECall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        
        self.callAPI_POST(filePath: "secure/notify", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
    //MARK:- CHANGE PASSWORD WS
    func post_ChangePass_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "rest_api/customer_change_password", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
    
    //MARK:- CMS PAGE API
    func get_CMSPAGE_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        let strUserId =  Global.kretriUserData().User_id!

        self.callAPI_GET(filePath:"rest_api/cms_page?device_uuid=\(Global.DeviceUUID)&customer_id=\(strUserId)" , params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }) {
            
        }        
    }
    
    //MARK:- CHANGE PASSWORD WS
    func post_Notification_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.callAPI_POST(filePath: "rest_api/settings", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            onFailure()
        })
    }
    
    //MARK:- EDIT PROFILE IMAGE UPLOAD
    func post_EDIT_Profile_Completion(image:UIImage?, params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess), onFailure: @escaping (AFAPIMasterFailure)) {
        self.callAPI_ImageUpload(filePath: "secure/customer_edit_profile", image:image , params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }) {
            onFailure()
        }
    }
    
    
    // MARK:-  FORGOT SCREEN
    func post_LogOutCall_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "secure/logout", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
 
    
    // MARK: -  Forgot Password API
    func getAllCategoryListApi_Completion(params: [String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        let strUserId =  Global.kretriUserData().User_id!
        self.callAPI_GET(filePath:"rest_api/categories?panel=app&device_uuid=\(Global.DeviceUUID)&customer_id=\(strUserId)", params: nil, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responceObj:Any, success:Bool) in
            onSuccess(responceObj)
        }, onFailure: {()  in
            
        })
    }
    
    // MARK: -  CustomerAddress API
    func getAllLocationAddressDetailListApi_Completion(strApiUrl:String,params: [String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_GET(filePath:strApiUrl, params: nil, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responceObj:Any, success:Bool) in
            onSuccess(responceObj)
        }, onFailure: {()  in
            
        })
    }
    
    
    // MARK: -  Edit Customer Address API
    func postEditCustomerAddress_Api_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        let strUserId =  Global.kretriUserData().User_id!

        self.callAPI_POST(filePath: "rest_api/add_edit_address?device_uuid=\(Global.DeviceUUID)&customer_id=\(strUserId)", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
    
    
    // MARK: -  Get Pramotional List API
    func getAllPramotionalListApi_Completion(params: [String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        let strUserId =  Global.kretriUserData().User_id!

        self.callAPI_GET(filePath:"rest_api/promotional?device_uuid=\(Global.DeviceUUID)&customer_id=\(strUserId)", params: nil, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responceObj:Any, success:Bool) in
            onSuccess(responceObj)
        }, onFailure: {()  in
            
        })
    }
    
    
    // MARK: -  FAQ API Call
    func getFAQListApi_Completion(params: [String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        let strUserId =  Global.kretriUserData().User_id!
        var strFaqLoginURl = ""
        if (Global.kretriUserData().IsLoggedIn!.toBool()) {
          strFaqLoginURl = "rest_api/faqs?panel=app&device_uuid=\(Global.DeviceUUID)&customer_id=\(strUserId)"
        } else  {
          strFaqLoginURl = "rest_api/faqs?panel=app&device_uuid=\(Global.DeviceUUID)"
        }

        self.callAPI_GET(filePath:strFaqLoginURl, params: nil, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responceObj:Any, success:Bool) in
            onSuccess(responceObj)
        }, onFailure: {()  in
            
        })
    }
    
    
    // MARK: -  Get Pramotional List API
    func getUserProfileDetailApi_Completion(strApiUrl:String,params: [String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_GET(filePath:strApiUrl, params: nil, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responceObj:Any, success:Bool) in
            onSuccess(responceObj)
        }, onFailure: {()  in
            
        })
    }
    
    // MARK: -  Edit Customer Address API
    func postEditCustomerProfile_Api_Completion(params:[String:Any]?, showLoader: Bool, enableInteraction: Bool, viewObj: UIView, onSuccess: @escaping (AFAPIMasterSuccess)) {
        self.callAPI_POST(filePath: "secure/customer_edit_profile", params: params, enableInteraction: enableInteraction, showLoader: showLoader, viewObj: viewObj, onSuccess: { (responseDict:Any, success:Bool) in
            if (success){
                onSuccess(responseDict)
            }
        }, onFailure:{ () in
            
        })
    }
}
