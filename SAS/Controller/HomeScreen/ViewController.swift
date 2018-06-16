//
//  ViewController.swift
//
//
//  Created by SAS
//  Copyright © 2018 self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SCREEN SHORT DETECTOR
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: .UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue, using: { note in
            // executes after screenshot
            if note != nil {
                print("Screenshot Detection : \(note)")
            }
            /*let screenshotAlert = UIAlertView(title: "Screenshot Detected", message: "Oh Oh no screenshot bruhh", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
             screenshotAlert.show()*/
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

