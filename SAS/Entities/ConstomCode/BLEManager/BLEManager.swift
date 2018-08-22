//
//  BLEManager.swift
//  StaterProject
//
//  Created by Ilesh Panchal on 21/02/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import SwiftyBluetooth
import CoreBluetooth
import SpinKit

enum RavasCommandState : String {
    case AutoTare = "1"
    case ManualTare = "2"
    case Zero = "3"
    case ManualClear = "4"
    case AutoClear = "5"
    case SNFired = "6"
    case GetTare = "7"
    case GetManualTare = "8"
    
    
}
enum BluetoothState : String {
    case unknown = "unknown"
    case resetting = "resetting"
    case unsupported = "unsupported"
    case unauthorized = "unauthorized"
    case poweredOff = "poweredOff"
    case poweredOn = "poweredOn"
    
}

typealias ScanningSuccess = (_ arrDevices:Peripheral) ->Void
typealias didConnecttoBluetooth = (_ Success:BluetoothState) ->Void
typealias didConnecttoRavas = (_ Success:Bool) ->Void
typealias ScanningFailure = (_ Error:String) ->Void

class BLEManager: NSObject {
    static let shared = TopsBLEManager()
    var isConnected : Bool = false
    var ConnectedPeripheral : Peripheral?
    var CurrentCommand: String = ""
    var lastResetValue:RavasCommandState = .Zero{
        didSet{
            Singleton.sharedSingleton.saveToUserDefaults(value: lastResetValue.rawValue, forKey: "lastResetValue")
        }
    }
    
    public static let ST = "ST"
    public static let SN = "SN"
    public static let GT = "GT"
    public static let RT = "RT"
    public static let SP = "SP"
    public static let RP = "RP"
    public static let GP = "GP"
    public static let SZ = "SZ"
    public static let GG = "GG"
    public static let GN = "GN"
    public static let GL = "GL"
    
    var currentBLEstatus : BluetoothState = .unknown
    let serviceUUID = CBUUID(string: Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_SERVICE)
    //MARK: Mendetory first implement // Set background mode on first please
    func setsharedinstance()
    {
        SwiftyBluetooth.setSharedCentralInstanceWith(restoreIdentifier: "tops.BLE.for.ravas")
        self.restorePeripheral()
    }
    
    func observeDisconnection()  {
        NotificationCenter.default.addObserver(self, selector: #selector(DisConnectManage), name: Notification.Name(rawValue: "DidDisconnectRavas"), object: nil)
    }
    
    @objc func DisConnectManage()
    {
        Global.appDelegate.hideStatusBar()
        TopsBLEManager.shared.isConnected = false
        if TopsBLEManager.shared.ConnectedPeripheral != nil{
            
            TopsBLEManager.shared.connectRAVAS(peripheral: self.ConnectedPeripheral!, Loader: false, userinteraction: true) { (finish) in
                TopsBLEManager.shared.WriteAscii(hexValue: TopsBLEManager.SN)
                
            }
        }
    }
    
    
    func connectRAVAS(peripheral: Peripheral, Loader:Bool, userinteraction:Bool, Success: @escaping didConnecttoRavas)
    {
        guard Central.sharedInstance.state == .poweredOn else {
            Success(true)
            return
        }
        
        let LoaderView = Global.appDelegate.navController?.view
        let view = DBManager.sharedInstance.addShowLoaderInView(viewObj: LoaderView!, boolShow: Loader, enableInteraction: userinteraction)
        if self.ConnectedPeripheral?.state == .connected {
            SwiftyBluetooth.stopScan()
            ConnectedPeripheral?.disconnect(completion: { (result) in
                Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.RAVASCREDENTIAL.ravasUUID)
                print(result)
                
                peripheral.connect(withTimeout: 30, completion: { (result) in
                    switch result {
                    case .success:
                        if peripheral.state == .connected{
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RavasDidConnected"), object: nil)
                            TopsBLEManager.shared.ConnectedPeripheral = peripheral
                            Singleton.sharedSingleton.saveToUserDefaults(value: peripheral.identifier.uuidString, forKey: Global.RAVASCREDENTIAL.ravasUUID)
                            self.DiscoverServicesandCharacteristics(Success: { (Finish) in
                                if Finish{
                                    TopsBLEManager.shared.isConnected = true
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RavasDidConnected"), object: nil)
                                    Global.appDelegate.showStatusBar(Peripheral: "\(peripheral.name ?? "Unknown")", Status: "Connected")
                                    Success(true)
                                }
                                else{
                                    TopsBLEManager.shared.isConnected = false
                                    Success(false)
                                }
                                DBManager.sharedInstance.hideRemoveLoaderFromView(removableView: view!, mainView: LoaderView!)
                            })
                        }
                        else
                        {
                            TopsBLEManager.shared.isConnected = false
                            DBManager.sharedInstance.hideRemoveLoaderFromView(removableView: view!, mainView: LoaderView!)
                        }
                        print("Connected successfully.")
                    break // You are now connected to the peripheral
                    case .failure(let error):
                        TopsBLEManager.shared.isConnected = false
                        print("\(error.localizedDescription)")
                        Success(false)
                        SwiftyBluetooth.stopScan()
                        Global.appDelegate.hideStatusBar()
                        DBManager.sharedInstance.hideRemoveLoaderFromView(removableView: view!, mainView: LoaderView!)
                        break // An error happened while connecting
                    }
                })
            })
        }
        else{
            SwiftyBluetooth.stopScan()
            peripheral.connect(withTimeout: 30, completion: { (result) in
                switch result {
                case .success:
                    if peripheral.state == .connected{
                        
                        TopsBLEManager.shared.ConnectedPeripheral = peripheral
                        Singleton.sharedSingleton.saveToUserDefaults(value: peripheral.identifier.uuidString, forKey: Global.RAVASCREDENTIAL.ravasUUID)
                        
                        self.DiscoverServicesandCharacteristics(Success: { (Finish) in
                            if Finish{
                                TopsBLEManager.shared.isConnected = true
                                Global.appDelegate.showStatusBar(Peripheral: "\(peripheral.name ?? "Unknown")", Status: "Connected")
                                Success(true)
                            }
                            else{
                                TopsBLEManager.shared.isConnected = false
                                Success(false)
                            }
                            DBManager.sharedInstance.hideRemoveLoaderFromView(removableView: view!, mainView: LoaderView!)
                        })
                        
                    }
                    
                    print("Connected successfully.")
                break // You are now connected to the peripheral
                case .failure(let error):
                    print(error.localizedDescription)
                    TopsBLEManager.shared.isConnected = false
                    Global.appDelegate.hideStatusBar()
                    DBManager.sharedInstance.hideRemoveLoaderFromView(removableView: view!, mainView: LoaderView!)
                    break // An error happened while connecting
                }
            })
        }
    }
    
    func ScanForRAVAS(uuid:String,timeout: Float ,success:@escaping ScanningSuccess, failure : @escaping ScanningFailure)  {
        
        let center = Central.sharedInstance
        if center.state == .poweredOff
        {
            Global.appDelegate.hideStatusBar()
            return
        }
        
        SwiftyBluetooth.stopScan()
        SwiftyBluetooth.scanForPeripherals(timeoutAfter: TimeInterval(timeout)) { (scanResult) in
            switch scanResult {
            case .scanStarted:
                print("Started Scanning")
                
            case .scanResult(let peripheral, let advertisementData, let RSSI):
                if uuid == peripheral.identifier.uuidString
                {
                    TopsBLEManager.shared.ConnectedPeripheral = nil
                    success(peripheral)
                }
                print()
            case .scanStopped(let error):
                print("\(error?.localizedDescription)")
                failure((error?.localizedDescription) ?? "")
                // The scan stopped, an error is passed if the scan stopped unexpectedly
            }
        }
    }
    
    func DiscoverServicesandCharacteristics(Success: @escaping didConnecttoRavas)
    {
        self.ConnectedPeripheral?.discoverServices(completion: { (result) in
            switch result{
            case .success(let services):
                for service in services{
                    if service.uuid.uuidString == Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_SERVICE{
                        self.ConnectedPeripheral?.discoverCharacteristics(withUUIDs: nil, ofServiceWithUUID: service.uuid, completion: { (Characteristics) in
                            
                            for characteristic in Characteristics.value! {
                                print(characteristic)
                                
                                if characteristic.properties.contains(.authenticatedSignedWrites) {
                                    print("\(characteristic.uuid): properties contains authenticatedSignedWrites")
                                    
                                }
                                if characteristic.properties.contains(.notifyEncryptionRequired) {
                                    print("\(characteristic.uuid): properties contains notifyEncryptionRequired")
                                    
                                }
                                if characteristic.properties.contains(.notify) {
                                    print("\(characteristic.uuid): properties contains .notify")
                                    self.didgetNotify()
                                    self.ConnectedPeripheral?.setNotifyValue(toEnabled: true, forCharacWithUUID: characteristic.uuid, ofServiceWithUUID: characteristic.service.uuid, completion: { (result) in
                                        if result.value ?? false{
                                            print("Success")
                                            
                                            self.WriteAscii(hexValue: TopsBLEManager.SN)
                                        }
                                        else{
                                            self.WriteAscii(hexValue: TopsBLEManager.SN)
                                        }
                                        Success(true)
                                    })
                                }
                            }
                        })
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                Success(false)
                break
            }
        })
    }
    
    func DisconnectRAVAS()
    {
        TopsBLEManager.shared.ConnectedPeripheral?.disconnect(completion: { (result) in
            TopsBLEManager.shared.ConnectedPeripheral = nil
            Singleton.sharedSingleton.saveToUserDefaults(value: "", forKey: Global.RAVASCREDENTIAL.ravasUUID)
            Global.appDelegate.hideStatusBar()
            TopsBLEManager.shared.isConnected = false
        })
    }
    
    func restorePeripheral()
    {
        NotificationCenter.default.addObserver(forName: Central.CentralManagerWillRestoreState,
                                               object: Central.sharedInstance,
                                               queue: nil)
        { (notification) in
            if let restoredPeripherals = notification.userInfo?["peripherals"] as? [Peripheral] {
                print("restored")
                for peri in restoredPeripherals{
                    if peri.identifier.uuidString == Global.RAVASCREDENTIAL.ravasUUID{
                        TopsBLEManager.shared.ConnectedPeripheral = peri
                        TopsBLEManager.shared.connectRAVAS(peripheral: peri, Loader: false,userinteraction: true, Success: { (finish) in
                            //"Connectedfromrestored"
                            
                        })
                    }
                }
            }
        }
    }
    
    func didgetNotify(){
        
        NotificationCenter.default.addObserver(forName: Peripheral.PeripheralCharacteristicValueUpdate,
                                               object: TopsBLEManager.shared.ConnectedPeripheral,
                                               queue: nil) { (notification) in
                                                let charac = notification.userInfo!["characteristic"] as! CBCharacteristic
                                                if let error = notification.userInfo?["error"] as? SBError {
                                                    // Deal with error
                                                    
                                                }
                                                else{
                                                    
                                                    var strV = String.init(data: charac.value!, encoding: .utf8) ?? ""
                                                    
                                                    let test = String(strV.filter { !" \n\t\r".contains($0) })
                                                    
                                                }
        }
    }
    
    func NotifyAscii()
    {
        //let data = String().data(using: String.Encoding.utf8)!
        if self.ConnectedPeripheral?.state == .connected {
            self.ConnectedPeripheral?.setNotifyValue(toEnabled: true, forCharacWithUUID: Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_NOTIFY, ofServiceWithUUID: Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_SERVICE, completion: { (result) in
                print(result)
                self.WriteAscii(hexValue: "GG")
            })
            
            
        }
        
    }
    
    func convertToHEX(str:String) ->String
    {
        let data = str.data(using: .utf8)!
        let hexString = data.map{ String(format:"%01x", $0) }.joined()
        return hexString
    }
    
    func WriteAscii(hexValue:String)
    {
        TopsBLEManager.shared.CurrentCommand = hexValue
        let string = String(self.convertToHEX(str: "\(hexValue)")+"0D")
        let byte = string.hexa2Bytes
        let commandData = NSData(bytes: byte, length: byte.count)
        
        //let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        if self.ConnectedPeripheral?.state == .connected {
            TopsBLEManager.shared.ConnectedPeripheral?.writeValue(ofCharacWithUUID: Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_WRITE, fromServiceWithUUID: Global.RAVASCREDENTIAL.CLIENT_CHARACTERISTIC_SERVICE, value: commandData as Data, type: .withResponse, completion: { (response) in
                print(response)
                if hexValue == "SN"{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidWriteSN"), object: nil)
                }
            })
        }
        
    }
    
    func ToSetAutoTarValue()
    {
        //Set The auto tar value to device, write the ST command for that
        self.WriteAscii(hexValue: TopsBLEManager.ST)
        
    }
    
}

