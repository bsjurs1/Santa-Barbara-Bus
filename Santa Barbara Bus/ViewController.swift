//
//  ViewController.swift
//  Santa Barbara Bus
//
//  Created by Bjarte Sjursen on 29/10/16.
//  Copyright © 2016 Bjarte Sjursen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var busstopTextField: UITextField!
    @IBOutlet weak var findDeparturesButton: UIButton!
    
    var sbmtdBusInfoUrlStrings = Array<String>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let sbmtdBusInfoUrl = URL(string: "http://sbmtd.gov/business-and-employment/purchasing.html")
        
        do{
            let myHTMLString = try String(contentsOf: sbmtdBusInfoUrl!, encoding: .ascii)
            let myHTMLDoc = HTML(rawDocument: myHTMLString)
           
            let HTMLAs = myHTMLDoc.a()!
            
            for elem in HTMLAs {
                for line in elem.document {
                    print(line)
                }
            }
            
            print(HTMLAs.count)
            
            
        }
        catch let error {
            print("Error: \(error)")
        }

    }
    
    func extractInfo(){
        
        let sbmtdUrl = URL(string: "http://sbmtd.gov/maps-and-schedules/24x.html")
        
        do {
            let myHTMLString = try String(contentsOf: sbmtdUrl!, encoding: .ascii)
            let myHTMLStringComponents = myHTMLString.components(separatedBy: "\n")
            
            for line in myHTMLStringComponents {
                
                if line.contains("ttpub") {
                    
                    let lineComponents = line.components(separatedBy: " ")
                    
                    for lineComponent in lineComponents {
                        if lineComponent.contains("src") {
                            let keyValue = lineComponent.components(separatedBy: "=")
                            for keyValueComponent in keyValue {
                                
                                if !keyValueComponent.contains("src") {
                                    let urlStringComponents = keyValueComponent.components(separatedBy: "\"")
                                    let url = urlStringComponents[1]
                                    //print(url)
                                    sbmtdBusInfoUrlStrings.append(url)
                                }
                            }
                        }
                    }
                }
            }
        }
        catch let error {
            print("Error: \(error)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func findDepartures(_ sender: UIButton) {
        
        //let busStop = busstopTextField.text!
        
        //Pass this to the API and find relevant information
        
        
        
        
    }
    


}

