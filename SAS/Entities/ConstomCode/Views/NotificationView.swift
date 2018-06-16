//
//  NotificationView.swift
//  Copyright © 2018 Self. All rights reserved.
//  Ilesh Commited :18/07

import UIKit

protocol NotificationViewDelete {
    func didHide()
}

class NotificationView: UIView {
    
    @IBOutlet weak var lblDiscr: UILabel!
    @IBOutlet weak var btnEmailNotification: IPAutoScalingButton!
    @IBOutlet weak var btnPushnotification: IPAutoScalingButton!
    @IBOutlet weak var btnCancle: IPAutoScalingButton!
    @IBOutlet weak var btnSave: IPAutoScalingButton!
    
    @IBOutlet weak var lblEmailIcon: IPAutoScalingLabel!
    @IBOutlet weak var lblPushIcon: IPAutoScalingLabel!
    var is_Push:Bool = false
    var is_Email:Bool = false
    var delegate:NotificationViewDelete?
    
    override func awakeFromNib() {
        
    }
    
    func setUpValues(){
        is_Push = (Global.kretriUserData().is_PushNoti?.toBool())!
        is_Email = (Global.kretriUserData().is_EmailNoti?.toBool())!
        ValueUpdateForPush()
        ValueUpdateForEmail()
    }
    
    private func ValueUpdateForPush(){
        if is_Push {
            lblPushIcon.isHidden = false
        }else{
            lblPushIcon.isHidden = true
        }
    }
    
    private func ValueUpdateForEmail(){
        if is_Email {
            lblEmailIcon.isHidden = false
        }else{
            lblEmailIcon.isHidden = true
        }
        
    }
    
    //MARK:- ACTION METHODS
    @IBAction func btnEmailClick(_ sender: UIButton) {
        if is_Email {
            is_Email = false
        }else{
            is_Email = true
        }
        ValueUpdateForEmail()
    }
    
    @IBAction func btnPushClick(_ sender: UIButton) {
        if is_Push {
            is_Push = false
        }else{
            is_Push = true
        }
        ValueUpdateForPush()
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        delegate?.didHide()
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        var  paramer: [String: Any] = [:]
        paramer["push_noti"] =  is_Push ? "1":"0"
        paramer["email_noti"] =  is_Email ? "1":"0"
        paramer["panel"] =  "app"
        paramer["customer_id"] = Global.kretriUserData().User_id
        paramer["device_uuid"] = Global.DeviceUUID
        
        AFAPIMaster.sharedAPIMaster.post_Notification_Completion(params: paramer, showLoader: true, enableInteraction: false, viewObj: (Global.appDelegate.window)!, onSuccess: { (result) in
            if let Dict = result as? NSDictionary {
                if let str = Dict.object(forKey:"status") as? String , str.toBool(){
                    Singleton.sharedSingleton.saveToUserDefaults(value: self.is_Email ? "1":"0", forKey: Global.kLoggedInUserKey.is_email_Noti)
                    Singleton.sharedSingleton.saveToUserDefaults(value: self.is_Push ? "1":"0" , forKey: Global.kLoggedInUserKey.is_push_noti)
                }else{
                    Singleton.sharedSingleton.showWarningAlert(withMsg:  Dict.object(forKey: "msg") as? String ?? "")
                }
            }
             self.delegate?.didHide()
        }, onFailure: {
             self.delegate?.didHide()
        })
    }
}
