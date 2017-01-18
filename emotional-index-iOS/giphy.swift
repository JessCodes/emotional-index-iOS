//
//  giphy.swift
//  emotional-index-iOS
//
//  Created by Anthony Tokatly on 1/16/17.
//  Copyright © 2017 tokatlystantilizers. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftGifOrigin
import KeychainAccess


class Giphy: UIViewController {
    var gif = ""
    
    
    
   
    @IBOutlet weak var viewGiph: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gif)
//        viewGiph.allowsInlineMediaPlayback = true
        
//      let scriptUrl = "https://emotemetoo.herokuapp.com/giphy"
        let scriptUrl = "http://localhost:3000/giphy"

  
      let keychain = Keychain(service: "com.tokatlys-tantilizers.emotional-index-iOS")
      let giphyUser = keychain[string: "user"]!
      
      // Add one parameter
      let urlWithParams = scriptUrl + "?id=\(giphyUser)"
    
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
            self.gif = responseString as! String
            print(self.gif)
            
            let url = URL(string: "https://media.giphy.com/media/\(self.gif)/giphy.gif")
            let data = try? Data(contentsOf: url!)
            self.viewGiph.image = UIImage.gif(data: data!)
            
        }
        
        task.resume()
        print(gif)
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
