//
//  Global.swift
//
//  Created by SAS on 6/13/17.
//  Copyright © 2017 Ilesh. All rights reserved.

import UIKit
class Global {
    
    static let DeviceUUID = UIDevice.current.identifierForVendor!.uuidString
    static let PhoneDigitLimit = 11
    static let UserNameDigitLimit = 50
    static let StreetNODigitLimit = 20
    static let StreetNameDigitLimit = 60

    static var IsOffline:Bool = false
    
    //MARK: - API BASE URL
    static let baseURLPath = "http://v.1.4/"  //M_1
   
    struct g_ws {
        static let Device_type: String! = "1"
    }
    
    struct SDKKeys {
        struct Twilio {
            static let Id = ""
            static let Secret = ""
            static let FromNumber = ""
            static let MsgURL = "https://api.twilio.com/2010-04-01/Accounts/" + Global.SDKKeys.Twilio.Id + "/Messages.json"
        }
        struct Adobe {
            static let ClientId = ""
            static let Secret = ""
        }
    }
    static var lastPhone:String = ""
    static var lastpass:String = ""
    static var lastrepass:String = ""

    
    struct AppUtility {
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            // Comment for unused
            //Global.appDelegate.orientationLock = orientation
        }
        
        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            
            self.lockOrientation(orientation)
            
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
        
    }
    
    //Device Compatibility
    struct is_Device {
        static let _iPhone = (UIDevice.current.model as String).isEqual("iPhone") ? true : false
        static let _iPad = (UIDevice.current.model as String).isEqual("iPad") ? true : false
        static let _iPod = (UIDevice.current.model as String).isEqual("iPod touch") ? true : false
    }
    
    //Display Size Compatibility
    struct is_iPhone {
        static let _X = (UIScreen.main.bounds.size.height == 2436 ) ? true : false
        static let _6p = (UIScreen.main.bounds.size.height >= 736.0 ) ? true : false
        static let _6 = (UIScreen.main.bounds.size.height <= 667.0 && UIScreen.main.bounds.size.height > 568.0) ? true : false
        static let _5 = (UIScreen.main.bounds.size.height <= 568.0 && UIScreen.main.bounds.size.height > 480.0) ? true : false
        static let _4 = (UIScreen.main.bounds.size.height <= 480.0) ? true : false
    }
    
    //IOS Version Compatibility
    struct is_iOS {
        static let _11 = ((Float(UIDevice.current.systemVersion as String))! >= Float(11.0)) ? true : false
        static let _10 = ((Float(UIDevice.current.systemVersion as String))! >= Float(10.0)) ? true : false
        static let _9 = ((Float(UIDevice.current.systemVersion as String))! >= Float(9.0) && (Float(UIDevice.current.systemVersion as String))! < Float(10.0)) ? true : false
        static let _8 = ((Float(UIDevice.current.systemVersion as String))! >= Float(8.0) && (Float(UIDevice.current.systemVersion as String))! < Float(9.0)) ? true : false
    }
    
    // MARK: -  Shared classes
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let singleton = Singleton.sharedSingleton

    
    // MARK: -  Screen size
    static let screenWidth : CGFloat = (Global.appDelegate.window!.bounds.size.width)
    static let screenHeight : CGFloat = (Global.appDelegate.window!.bounds.size.height)
    
    // MARK: -  Get UIColor from RGB
    public func RGB(r: Float, g: Float, b: Float, a: Float) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a))
    }
    
    // MARK: -  Dispatch Delay
    func delay(delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

   // MARK: -  Application Colors
   struct kAppColor {
        static let PrimaryBlue =  #colorLiteral(red: 0.1254901961, green: 0.2431372549, blue: 0.4862745098, alpha: 1)   //Global().RGB(r: 47.0, g: 128.0, b: 209.0, a: 1.0)
        static let PrimaryYellow =  #colorLiteral(red: 1, green: 0.7764705882, blue: 0.03921568627, alpha: 1)
    
        static let SecondaryGrey =  #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        static let SecondaryBlue365188 =  #colorLiteral(red: 0.2117647059, green: 0.3176470588, blue: 0.5333333333, alpha: 1)
        static let SecondaryBlue4059 =  #colorLiteral(red: 0.2509803922, green: 0.3490196078, blue: 0.5607843137, alpha: 1)
        static let SecondaryWightF7 =  #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        static let SecondaryWightF1E =  #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9411764706, alpha: 0.796403104) // for place holder
        static let SecondaryCopyWightF1E =  #colorLiteral(red: 0.9450980392, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        static let SecondaryRed =  #colorLiteral(red: 0.862745098, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
    
   }

    // MARK: - Application Fonts
    struct kFont {
        static let Proxima_Semibold = "ProximaNova-Semibold"
        static let Proxima_Bold = "ProximaNova-Bold"
        static let Proxima_Regular = "ProximaNova-Regular"
        static let AlcoholFont = "Alcohol_TOPS"
    }

    struct kFontSize {
        static let  TextFieldSmallSize_8:CGFloat = 8
        static let  TextFieldSize:CGFloat = 12
        static let  ButtonSize:CGFloat = 15
        static let  LabelSize:CGFloat = 14
    }
    
    struct g_UserDefaultKey {
        static let DeviceToken: String! = "DEVICE_TOKEN"
    }
    
    struct kAddActivity {
        static let  SelectLifeEvents = "Select Life Events"
        
    }
    func getDeviceSpecificFontSize(_ fontsize: CGFloat) -> CGFloat {
        return ((Global.screenWidth) * fontsize) / 320
    }
    
    struct is_Reachablity {
        var isNetwork = Global.singleton.isConnectivityChecked()
    }
    
//    func getLocalizeStr(key: String) -> String {
//        return LocalizeHelper.sharedLocalSystem().localizedString(forKey: key)
//    }

    // MARK: -  User Data
    struct kLoggedInUserKey {
        static let IsLoggedIn: String! = "ALUserIsLoggedIn"
        static let IsAddAddress: String! = "ALUserIsAddAddress"
        static let User_id: String! = "AL_UserId"
        static let FB_id: String! = "AL_FBId"
        static let Google_id: String! = "AL_GoogleId"
        static let FullName: String! = "AL_UserFullName"
        static let user_roles:String = "AL_isuser_roles"
        static let user_type:String = "AL_isuser_type"
        static let user_Image:String = "user_profile_image"
        static let Email: String! = "AL_UserEmail"
        static let name: String! = "AL_UserName"
        static let Gender: String! = "AL_UserGender"
        static let phone: String! = "AL_UserMobileNumber"
        static let CountryCode: String! = "AL_UserCountryCode"
        static let CountryName: String! = "AL_UserCountryName"
        static let DOB: String! = "AL_UserDOB"
        static let AccessToken: String! = "AL_UserAccessToken"
        static let refresh_token:String = "PhoneUserLoggedin"
        static let Billing_address:String = "ship_to_bill_address"
        
        // NOTIFICATION FLAG
        static let is_email_Noti:String = "email_noti"
        static let is_email_Subscription:String = "email_subscribe"
        static let is_push_noti:String = "push_noti"
        static let is_Registertype:String = "registered_type"
        
    }
    
    struct kretriUserData {
        var name: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.FullName)
        var strFBID: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.FB_id)
        var strGoogleID: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Google_id)
        var IsLoggedIn: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsLoggedIn)
        var IsAddedAddress: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.IsAddAddress)
        var User_id: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.User_id)
        var Email: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.Email)
        var AccessToken: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.AccessToken)
        var refresh_token: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.refresh_token)
        var strProfile: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.user_Image)
        var is_EmailNoti: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.is_email_Noti)
        var is_PushNoti: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.is_push_noti)
        var user_roles: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.user_roles)
        var user_type: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.user_type)
        var registered_type: String? = Global.singleton.retriveFromUserDefaults(key: Global.kLoggedInUserKey.is_Registertype)
    }
    
    // MARK: -  String Type for Validation
    enum kStringType : Int {
        case AlphaNumeric
        case AlphabetOnly
        case NumberOnly
        case Fullname
        case Username
        case Email
        case PhoneNumber
    }
    
    struct PhoneType {
        static let mobile: String = "mobile"
        static let home: String = "home"
        static let work: String = "work"
        static let fax: String = "fax"
        static let other: String = "other"
    }
    
    struct AddressType {
        static let home: String = "home"
        static let work: String = "work"
        static let billing: String = "billing"
        static let shipping: String = "shipping"
        static let other: String = "other"
        
    }
    
    // MARK: -  Post Media Type
    struct kGoogleApiKey {
        static let strPlaceAPIKey = "AIzaSyBlwDGf2y197x-6VRDYRU20BwvBxmn_aY4"
    }
    
    struct kGoogleApis {
        static let strContactApi = "https://www.googleapis.com/auth/contacts.readonly"
    }
    
    struct SocialKeys {
        static let facebook: String = "facebook"
        static let twitter: String  = "twitter"
        static let google: String = "google"
        static let skype: String = "skype"
        static let linkedin: String = "linkedin"
        static let website: String = "website"
    }
    
    struct DatesName {
        static let BirthDay: String = "birthday"
    }
    
    // MARK: -  Create Post: Text Theme Colors
    struct kTextThemeColor {
        static let Start_1 = Global().RGB(r: 248, g: 248, b: 141, a: 1).cgColor
        static let End_1 = Global().RGB(r: 248, g: 248, b: 141, a: 1).cgColor
        
        static let Start_2 = Global().RGB(r: 86, g: 229, b: 159, a: 1).cgColor
        static let End_2 = Global().RGB(r: 40, g: 187, b: 230, a: 1).cgColor
        
        static let Start_3 = Global().RGB(r: 74, g: 144, b: 226, a: 1).cgColor
        static let End_3 = Global().RGB(r: 74, g: 144, b: 226, a: 1).cgColor
        
        static let Start_4 = Global().RGB(r: 220, g: 56, b: 246, a: 1).cgColor
        static let End_4 = Global().RGB(r: 97, g: 63, b: 219, a: 1).cgColor
        
        static let Start_5 = Global().RGB(r: 243, g: 83, b: 105, a: 1).cgColor
        static let End_5 = Global().RGB(r: 243,g: 83, b: 105, a: 1).cgColor
        
        static let Start_6 = Global().RGB(r: 252, g: 209, b: 114, a: 1).cgColor
        static let End_6 = Global().RGB(r: 244, g: 89, b: 106, a: 1).cgColor
        
        static let Start_7 = Global().RGB(r: 137, g: 250, b: 147, a: 1).cgColor
        static let End_7 = Global().RGB(r: 137, g: 250, b: 147, a: 1).cgColor
        
        static let Start_8 = Global().RGB(r: 255, g: 150, b: 225, a: 1).cgColor
        static let End_8 = Global().RGB(r: 255, g: 150, b: 225, a: 1).cgColor
    }
}
