//
//  SecondViewController.swift
//  MTConnect_tests
//
//  Created by Steven Peregrine on 2/8/19.
//  Copyright © 2019 ITAMCO. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SWXMLHash
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var machineName:UILabel!
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView:UIView!
    @IBOutlet var viewPicker: UISegmentedControl!
    
    @IBOutlet var CurrentSwitch : UISwitch!
    @IBOutlet var CurrentStepper : UIStepper!
    @IBOutlet var CurrentTick : UITextField!
    
    @IBOutlet weak var powerImage: UIImageView!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var axesTable: UITableView!
    
    
    var passedURL:String?
    
    weak var timer: Timer?
    
    var isSpindle = false
    var isLinear = false
    var isRotary = false
    var isPower = false
    var isController = false
    
   
    
    var spindle:Array<String> = []
    var linear:Array<String> = []
    var rotary:Array<String> = []
    var power:String!
    var controller:Array<String> = []
    
    var currentSpindleDict:[String:String] = [:]
    var currentLinearDict:[String:String] = [:]
    var currentRotaryDict:[String:String] = [:]
    var currentPowerDict:[String:String] = [:]
    var currentControllerDict:[String:String] = [:]
    
    var masterArray:Array<String> = []
    var currentMasterDict:[String:String] = [:]
    
    var eventArray:Array<String> = []
    var currentEventDict:[String:String] = [:]
    
    var myColor:UIColor?
    var canChangeView = true
    override func viewDidAppear(_ animated: Bool) {
        
  
        
        
        
        myColor = CurrentStepper.tintColor
           print("Passed Value: " + (passedURL ?? "nan")!)
        Alamofire.request(passedURL!+"/probe").responseString{response in
            print(" - API url: \(String(describing: response.request!))")   // original url request
            var statusCode = response.response?.statusCode
            
            switch response.result {
            case .success:
                
                print("status code is: \(String(describing: statusCode))")
                if let string = response.result.value {
                    
                    let xml = SWXMLHash.parse(string)
                    let machineName = xml["MTConnectDevices"]["Devices"]["Device"].element?.attribute(by: "name")?.text
                    self.machineName.text = machineName
                    //Sets the variables to false
                    self.isSpindle = false
                    self.isLinear = false
                    self.isRotary = false
                    self.isPower = false
                    self.isController = false
                    //Then checks one by one which ones to set to true
                    if xml["MTConnectDevices"]["Devices"]["Device"]["Components"]["Axes"]["Components"]["Spindle"].description != "" {
                        self.isSpindle = true
                    }
                    
                    
                    if xml["MTConnectDevices"]["Devices"]["Device"]["Components"]["Axes"]["Components"]["Linear"].description != "" {
                        self.isLinear = true
                    }
                    
                    
                    if  xml["MTConnectDevices"]["Devices"]["Device"]["Components"]["Axes"]["Components"]["Rotary"].description != "" {
                        self.isRotary = true
                    }
                    
                    
                    if xml["MTConnectDevices"]["Devices"]["Device"]["Components"]["Power"].description != "" {
                        self.isPower = true
                    }
                    
                    if xml["MTConnectDevices"]["Devices"]["Device"]["Components"]["Controller"].description != "" {
                        self.isController = true
                    }
        
                    print("isSpindle: " + String(self.isSpindle))
                    print("isLinear: " + String(self.isLinear))
                    print("isRotary: " + String(self.isRotary))
                    print("isPower: " + String(self.isPower))
                    print("isController: " + String(self.isController))
                    self.Current()
                }
            case .failure(let error):
                statusCode = error._code // statusCode private
                print("status code is: \(String(describing: statusCode))")
                print(error)
            }
        }
    }
    @IBAction func SegmentChanged(){
        if viewPicker.selectedSegmentIndex == 0
        {
            firstView.isHidden = false
            secondView.isHidden = true
            thirdView.isHidden = true
        }
        if viewPicker.selectedSegmentIndex == 1
        {
            firstView.isHidden = true
            secondView.isHidden = false
            thirdView.isHidden = true
        }
        if viewPicker.selectedSegmentIndex == 2
        {
            firstView.isHidden = true
            secondView.isHidden = true
            thirdView.isHidden = false
        }
    }
  
    //Prevent segue in middle of timer operation
    //SEGUE STUFFS
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        
       if canChangeView == true
       {
        timer?.invalidate()
        return true
        }
        return false
    }
 
    
    
    //---------------------------------------------------------------------------------------------------
    //Current
    //---------------------------------------------------------------------------------------------------
    @IBAction func CheckCurrentSwitch()
    {
    Current()
    }
    
    func Current() {
        
        if CurrentSwitch.isOn
        {
            
          
            CurrentStepper.isEnabled = false
            CurrentStepper.tintColor = UIColor.gray
            timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
            timer = Timer.scheduledTimer(withTimeInterval: CurrentStepper.value , repeats: true) { [weak self] _ in
             
                
                    
        self?.canChangeView = false
                    self!.spindle.removeAll()
                    self!.linear.removeAll()
                    self!.rotary.removeAll()
                   // self!.power.removeAll()
                    self!.controller.removeAll()
                    self!.currentSpindleDict.removeAll()
                    self!.currentLinearDict.removeAll()
                    self!.currentRotaryDict.removeAll()
                    self!.currentPowerDict.removeAll()
                    self!.currentControllerDict.removeAll()
                    
                    self!.masterArray.removeAll()
                    self!.currentMasterDict.removeAll()
                
                    self!.eventArray.removeAll()
                    self!.currentEventDict.removeAll()
                    
                Alamofire.request(self!.passedURL! + "/current").responseString{response in
                        print(" - API url: \(String(describing: response.request!))")   // original url request
                        var statusCode = response.response?.statusCode
                        
                        switch response.result {
                        case .success:
                            
                            print("status code is: \(String(describing: statusCode))")
                            if let string = response.result.value {
                                
                                let xml = SWXMLHash.parse(string)
                                let dataPoints = try! xml["MTConnectStreams"]["Streams"]["DeviceStream"]["ComponentStream"].all
                                
                                for item in dataPoints
                                {
                                    
                                    
                                    if  item.element?.value(ofAttribute: "component") == "Power"  && self?.isPower == true
                                    {
                                        self?.power = (try! item.withAttribute("component", "Power")["Events"]["PowerState"].element?.text)
                                        self!.powerLabel.text = self?.power
                                        if self?.power == "ON"
                                        {
                                            self!.powerImage.image = UIImage(named: "on.png")
                                        }
                                        else
                                        {
                                            self!.powerImage.image = UIImage(named: "off.png")
                                        }
                                    }
                                    
                                    if  item.element?.value(ofAttribute: "component") == "Spindle"  && self?.isSpindle == true
                                    {
                                        let spindle = (try! item.withAttribute("component", "Spindle")["Samples"].children )
                                        for item in spindle
                                        {
                                            self!.spindle.append((item.element?.value(ofAttribute: "name"))!)
                                            self!.currentSpindleDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                            self!.currentMasterDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                        }
                                    }
                                    
                                    if  item.element?.value(ofAttribute: "component") == "Linear"  && self?.isLinear == true
                                    {
                                        let linear = (try! item.withAttribute("component", "Linear")["Samples"].children )
                                        for item in linear
                                        {
                                            self!.linear.append((item.element?.value(ofAttribute: "name"))!)
                                            self!.currentLinearDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                            self!.currentMasterDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                        }
                                    }
                                    
                                    if  item.element?.value(ofAttribute: "component") == "Rotary"  && self?.isRotary == true
                                    {
                                        let rotary = (try! item.withAttribute("component", "Rotary")["Samples"].children )
                                        for item in rotary
                                        {
                                            self!.rotary.append((item.element?.value(ofAttribute: "name"))!)
                                            self!.currentRotaryDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                            self!.currentMasterDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                        }
                                    }
                                    
                                    if  item.element?.value(ofAttribute: "component") == "Controller"  && self?.isController == true
                                    {
                                        let events = (try! item.withAttribute("component", "Controller")["Events"].children )
                                        for item in events
                                        {
                                            self!.eventArray.append((item.element?.value(ofAttribute: "name"))!)
                                            self!.currentEventDict[(item.element?.value(ofAttribute: "name"))!] = (item.element!.text )
                                            self!.eventTable.reloadData()
                                        }
                                    }
                                    
                                }
                                
                                
                                
                                
                               do
                               {
                                self?.masterArray = self!.spindle + self!.linear + self!.rotary
                               }
                                catch
                                {
                                  self?.masterArray = []
                                }
                                
                                
                              
                                
                                self?.axesTable.reloadData()
                                self?.canChangeView = true
                            }
                            
                        case .failure(let error):
                            statusCode = error._code // statusCode private
                            print("status code is: \(String(describing: statusCode))")
                            print(error)
                               self?.canChangeView = true
                        }
                    }
                }
              timer?.fire()
            
            
            
            
            
            
            
        }
        else
        {
            timer?.invalidate()
            
            CurrentStepper.isEnabled = true
            CurrentStepper.tintColor = myColor
            
        }
        
    }
    
    
    @IBAction func TickValueChanged() {
        CurrentTick.text = String(CurrentStepper.value) + " sec."
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        stopTimer()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == axesTable
        {
            return masterArray.count
        }
        else if tableView == eventTable
        {
            return eventArray.count
        }
        return 0
       
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == axesTable && indexPath.row <= self.masterArray.count
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AxesCell") as! CurrentCell
        cell.NameLabel.text = self.masterArray[indexPath.row]
        cell.ValueLabel.text = self.currentMasterDict[self.masterArray[indexPath.row]]
        
        return cell
        }
        else if tableView == eventTable && indexPath.row <= eventArray.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! CurrentCell
            cell.NameLabel.text = self.eventArray[indexPath.row]
            cell.ValueLabel.text = self.currentEventDict[self.eventArray[indexPath.row]]
            
            return cell
        }
        return UITableViewCell()
    }
    
}




class CurrentCell: UITableViewCell {
    //this defines all the outlets inside of the prototype cell
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ValueLabel: UILabel!
}
