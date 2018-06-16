// IleshPanchalNotificationManager.swift
//
//  Created by Self on 6/2/17.
//  Copyright © 2017 Self. All rights reserved.


import UIKit

class IPNotificationManager: NSObject {
    
    var dicNotification : NSDictionary?
    var intState :Int = 0
    
    private override init() {
        
    }
    
    static let shared: IPNotificationManager = {
        let instance = IPNotificationManager()
        return instance
    }()
    
    //MARK: - ACTIVE STATE NOTIFICATION IN IOS 10
    func GetPushProcessDataWhenActive(dictNoti:NSDictionary){
        intState = UIApplication.shared.applicationState.rawValue
        self.dicNotification = dictNoti
        if (Global.kretriUserData().IsLoggedIn!.toBool()) {
            DisplayNotification()
        }
    }
    
    func DisplayNotification() -> Void  {
        if let strMSG = dicNotification?.value(forKeyPath: "aps.alert") as? String {
            let alertView = UIAlertController(title: "", message:strMSG, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            let vc = Global.appDelegate.window?.rootViewController
            vc?.present(alertView, animated: true, completion: nil)
        }
        else if let strMSG = dicNotification?.value(forKeyPath: "aps.data.message") as? String {
            let alertView = UIAlertController(title: "", message:strMSG, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                
            })
            alertView.addAction(action)
            let vc = Global.appDelegate.window?.rootViewController
            vc?.present(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK: - SEND NOTIFICATION FOR INACTIVE AND BACKGROND STATE
    func GetPushProcessData(dictNoti:NSDictionary){
        intState = UIApplication.shared.applicationState.rawValue
        self.dicNotification = dictNoti
        if (Global.kretriUserData().IsLoggedIn!.toBool()) {
            NSLog("Login --- 1" )
            handlePushNotification()
        }
        
    }
    
    //MARK: - 1ft NOTIFICATION
    func handlePushNotification() -> Void {
        
        /*if Global.appDelegate.navController == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                NSLog("handlePushNotifBasedOnNotifType --- 2" )
                self.handlePushNotifBasedOnNotifType()
            }
        }else{
            NSLog("handlePushNotifBasedOnNotifType --- 2" )
            self.handlePushNotifBasedOnNotifType()
        }*/
    }
    
    //MARK:- 2nd NOTIFICATION
    func handlePushNotifBasedOnNotifType() -> Void {
        NSLog("handlePushNotifBasedOnNotifType --- 1-2")
        if let flag = dicNotification?.value(forKeyPath: "aps.data.flag") as? Int {
            if flag == 1 {                  //The object you are using since 8 hours.
                self.PushBookingScreen()
            }else if flag == 2{             //
                self.PushBookingScreen()
            }else if flag == 3 {            //You are going away from the distance 100 km OR current location bike is unavailable.
                self.PushBookingScreen()
            }else if flag == 4 {            //The bike is now available at the location
                self.PushDetailsScreen()
            }else if flag == 5 {            //3 new kubes and 4 new bikes are added at the location Sundarvan - AHMD
                self.PushDetailsScreen()
            }else{
                self.DisplayNotification()
            }
        }
        
    }
    
    //MARK:- BOOKING PUSH VIEW CONTROLLER
    func PushBookingScreen() -> Void {
       /* if Singleton.shared.is_BookingVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSLog("PushBookingScreen --- 3" )
                let bid = (self.dicNotification?.value(forKeyPath: "aps.data.booking_id") as? String ?? "0")
                let Oid = (self.dicNotification?.value(forKeyPath: "aps.data.object_id") as? String ?? "0")
                let DataDict:[String: String] = ["booking_id": bid,"object_id":Oid]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Global.notification.Push_forBookingTrip), object: DataDict)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                NSLog("PushBookingScreen --- 3" )
                let bookingDetails = BookingTripVC(nibName: "BookingTripVC", bundle: nil)
                bookingDetails.is_FromNotification = true
                bookingDetails.data.strBookingID = (self.dicNotification?.value(forKeyPath: "aps.data.booking_id") as? String ?? "0")
                bookingDetails.bikeDataObj.strId = (self.dicNotification?.value(forKeyPath: "aps.data.object_id") as? String ?? "0")
                Global.appdel.homeObj?.navigationController?.pushViewController(bookingDetails, animated: true)
                //Global.appdel.nav?.pushViewController(bookingDetails, animated: true)
                print("Hello booking")
            }
        }*/
    }
    
    func PushDetailsScreen() -> Void {
        /*if Singleton.shared.is_LocationVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NSLog("PushDetailsScreen --- 3" )
                let id = (self.dicNotification?.value(forKeyPath: "aps.data.location_id") as? String ?? "0")
                let DataDict:[String: String] = ["location_id": id]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Global.notification.Push_forLocation), object: DataDict)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                NSLog("PushDetailsScreen --- 3" )
                let deviceObj = DeviceDetailsVC(nibName: "DeviceDetailsVC", bundle: nil)
                deviceObj.is_FromNotification = true
                deviceObj.strId = (self.dicNotification?.value(forKeyPath: "aps.data.location_id") as? String ?? "0")
                Global.appdel.homeObj?.navigationController?.pushViewController(deviceObj, animated: true)
                //Global.appdel.nav?.pushViewController(deviceObj, animated: true)
            }
        }*/
        
        print("Device Details screen")
    }
}


extension UIViewController {
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    public var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}
