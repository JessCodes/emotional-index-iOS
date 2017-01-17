//
//  login.swift
//  emotional-index-iOS
//
//  Created by Anthony Tokatly on 1/17/17.
//  Copyright © 2017 tokatlystantilizers. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import KeychainAccess


class login: UIViewController {
    
    var confirmLogin = ""
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var logo: UIImageView!
    
    @IBAction func submit(_ sender: Any) {
       let passwordText = password.text!
       let emailText = email.text!
        
        
//       let scriptUrl = "https://emotemetoo.herokuapp.com/youtube"
         let scriptUrl = "http://localhost:3000/login_swift"
     
        
        // Add one parameter
        let urlWithParams = scriptUrl + "?email=\(emailText)&password=\(passwordText)"
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl as! URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            // Setting session from API backend
            self.confirmLogin = responseString as! String
            let keychain = Keychain()
            try! keychain.set(self.confirmLogin, key: "user")
            print(keychain["user"])
            
            
//            @IBAction func saveAction(sender: UIBarButtonItem) {
//                let keychain: Keychain
//                if let service = serviceField.text, !service.isEmpty {
//                    keychain = Keychain(service: service)
//                } else {
//                    keychain = Keychain()
//                }
//                keychain[usernameField.text!] = passwordField.text
//                
//                dismiss(animated: true, completion: nil)
//            }
            
        }
        
        task.resume()
        print(confirmLogin)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    }
