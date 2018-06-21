//
//
//
//  Created by Self on 11/16/17.
//  Copyright © 2017   All rights reserved.
//


import Foundation
import UIKit

// MARK: - Methods
public extension UINavigationController {
    
//    /// Pop ViewController with completion handler.
//    ///
//    /// - Parameter completion: optional completion handler (default is nil).
//    public func popViewController(_ completion: (() -> Void)? = nil) {
//        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
//        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
//        popViewController(animated: true)
//        CATransaction.commit()
//    }
//
//    /// Push ViewController with completion handler.
//    ///
//    /// - Parameters:
//    ///   - viewController: viewController to push.
//    ///   - completion: optional completion handler (default is nil).
//    public func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
//        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
//        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
//        pushViewController(viewController, animated: true)
//        CATransaction.commit()
//    }
    
    /// Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
    
    public func ConfiguredNavigationBar(isHidden:Bool,titleText:String?,viewController:UIViewController?,barColors:UIColor = UIColor.white,showShadowImage:Bool = false, shadowColor:String = "FFFFFF") {
        
        self.setNavigationBarHidden(isHidden, animated: true)
        viewController?.navigationItem.hidesBackButton = true
        let frame = CGRect(x: 0, y: 5, width: 200, height: 40)
        let tlabel = UILabel(frame: frame)
        tlabel.text = titleText
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 17.0) // Make here your customfonts
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        viewController?.navigationItem.titleView = tlabel
        self.navigationBar.setColors(background: barColors, text: UIColor.hexString("131010"))
        if showShadowImage {
            self.navigationBar.shadowImage = #imageLiteral(resourceName: "nav_shadow_img")
        }
        else {
            self.navigationBar.shadowImage = UIImage()
        }

    }
    
}