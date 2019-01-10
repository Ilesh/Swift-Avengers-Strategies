//
//  TimerButton.swift
//  Recruitd
//
//  Created by macmini on 10/01/19.
//  Copyright © 2019 Recritd Ltd. All rights reserved.
//

import Foundation
import UIKit

class TimerButton: UIButton {
    
}

class JobTime { // Every Miller should have a Cat
    var date:Date = Date()
    var isBooked = false
}

private var catKey: UInt8 = 0
extension TimerButton {
    var jobs: JobTime { // cat is *effectively* a stored property
        get {
            return associatedObject(base: self, key: &catKey)
            { return JobTime() } // Set the initial value of the var
        }
        set { associateObject(base: self, key: &catKey, value: newValue) }
    }
}

func associatedObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}
