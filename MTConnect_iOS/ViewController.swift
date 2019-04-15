//
//  ViewController.swift
//  MTConnect_tests
//
//  Created by Steven Peregrine on 2/6/19.
//  Copyright © 2019 ITAMCO. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var CurrentList: UITableView!

    var urlArray:Array<String> = []
    var urlDictionary:[String:String] = [:]
    
     let defaults = UserDefaults.standard
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  self.defaults.set([], forKey: "urlarray")
     //   self.defaults.set([:], forKey: "urldict")
        
       
       
        
        self.urlArray = self.urlArray.sorted()
        self.CurrentList.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if let storedUrlarray = defaults.array(forKey: "urlarray")
        {
            self.urlArray = storedUrlarray as! Array<String>
            print(self.urlArray)
        }
        else
        {
            print("URL Array not found")
        }
        if let storedUrlDict = defaults.dictionary(forKey: "urldict")
        {
            self.urlDictionary = storedUrlDict as! [String : String]
              print(self.urlDictionary)
        }
        else
        {
            print("URL Dict not found")
        }
        self.urlArray = self.urlArray.sorted()
        self.CurrentList.reloadData()
    }
    
    //Add a Machine
    @IBAction func AddMachine()
    {
        let alert = UIAlertController(title: "Please Enter Machine URL", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your URL here..."
          //  textField.text = "http://shoptalk2.itamco.com:5001"
             textField.text = "http://"
            textField.keyboardType = UIKeyboardType.URL
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let url = alert.textFields?.first?.text {
                print("Your name: \(url)")
                Alamofire.request(url+"/probe").responseString{response in
                    print(" - API url: \(String(describing: response.request!))")   // original url request
                    var statusCode = response.response?.statusCode
                    
                    switch response.result {
                    case .success:
                        
                        print("status code is: \(String(describing: statusCode))")
                        if let string = response.result.value {
                           
                            let xml = SWXMLHash.parse(string)
                            let machineCount:Int = xml["MTConnectDevices"]["Devices"].children.count
                            if machineCount == 1
                            {
                                let machineName = try! xml["MTConnectDevices"]["Devices"]["Device"].element?.attribute(by: "name")?.text
                                if self.urlDictionary[url] == nil
                                {
                                self.urlDictionary[url] = machineName!
                                self.urlArray.append(url)
                                  self.defaults.set(self.urlArray, forKey: "urlarray")
                                  self.defaults.set(self.urlDictionary, forKey: "urldict")
                              
                            
                                   
                                   
                                    
                                  
                                    
                                    
                                }
                            }
                            else
                            {
                                let notice = UIAlertController(title: "Multiple machines found with URL", message: "Do you wish to add them?", preferredStyle: .alert)
                                
                                notice.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                                    
                                    let machines = xml["MTConnectDevices"]["Devices"]["Device"].all
                                    
                                    for item in machines
                                    {
                                        let machineName = item.element?.attribute(by: "name")?.text
                                        if self.urlDictionary[url + "/" + machineName!] == nil
                                        {
                                        self.urlDictionary[url + "/" + machineName! ] = machineName!
                                        self.urlArray.append(url + "/" + machineName!)
                                        }
                                    }
                                    self.defaults.set(self.urlArray, forKey: "urlarray")
                                    self.defaults.set(self.urlDictionary, forKey: "urldict")
                                    self.urlArray = self.urlArray.sorted()
                                     self.CurrentList.reloadData()
                                }))
                                notice.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                self.present(notice, animated: true)
                               
                            }
                          self.urlArray = self.urlArray.sorted()
                            self.CurrentList.reloadData()
                        
                          
                            
                        }
                    case .failure(let error):
                        statusCode = error._code // statusCode private
                        print("status code is: \(String(describing: statusCode))")
                        print(error)
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    //---------------------
    //-----TABLEVIEW
    //---------------------
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue" {
            let cell = sender as! URLCell
            let vc = segue.destination as! SecondViewController
            vc.passedURL = cell.URLLabel.text // or custom label
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return urlArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell") as! URLCell
        cell.NameLabel.text = self.urlDictionary[self.urlArray[indexPath.row]]
        cell.URLLabel.text = self.urlArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            urlDictionary.removeValue(forKey: self.urlArray[indexPath.row])
            urlArray.remove(at: indexPath.row)
            
            self.defaults.set(self.urlArray, forKey: "urlarray")
            self.defaults.set(self.urlDictionary, forKey: "urldict")
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}

class URLCell: UITableViewCell {
    //this defines all the outlets inside of the prototype cell
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var URLLabel: UILabel!
}

