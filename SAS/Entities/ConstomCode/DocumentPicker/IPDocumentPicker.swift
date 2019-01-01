//
//  IPDocumentPicker.swift
//
//
//  Created by Ilesh on 22/11/18.
//  Copyright © 2018 Recritd Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices

class IPDocumentPicker :NSObject,UIDocumentPickerDelegate {

    static let shared = IPDocumentPicker()
    
    typealias complitionHandler = (Bool,URL?) -> Swift.Void
    private var block : complitionHandler?
    
    func OpenDocumentpicker(controller:UIViewController, response: @escaping complitionHandler){
        let types = [kUTTypePDF,"com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",] as [Any]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.delegate = self
        block = response
        documentPicker.modalPresentationStyle = .formSheet
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIDocumentBrowserViewController.self]).tintColor = UIColor.black
        controller.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("IPDocumentPicker :- Cancelled ")
        self.block?(true,nil) // isCancel,nil
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("IPDocumentPicker URL:- \(urls)")
        self.block?(false,urls.first)
    }
}

/*extension IPDocumentPicker: UIDocumentPickerDelegate {
   
    
}*/
