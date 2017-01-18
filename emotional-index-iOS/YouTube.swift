//
//  YouTube.swift
//  emotional-index-iOS
//
//  Created by Anthony Tokatly on 1/14/17.
//  Copyright © 2017 tokatlystantilizers. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

class YouTube: UIViewController {
    var video = ""
    
    @IBOutlet weak var videoView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(video)
        videoView.allowsInlineMediaPlayback = true
        
//        let scriptUrl = "https://emotemetoo.herokuapp.com/youtube"
        let scriptUrl = "http://localhost:3000/youtube"
      
        let keychain = Keychain(service: "com.tokatlys-tantilizers.emotional-index-iOS")
        let youtubeUser = keychain[string: "user"]!

      
        // Add one parameter
        let urlWithParams = scriptUrl + "?id=\(youtubeUser)"
      
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
            self.video = responseString as! String
            self.videoView.loadHTMLString("<iframe width=\"\(self.videoView.frame.width)\" height=\"\(self.videoView.frame.height)\" src=\"https://www.youtube.com/embed/\(self.video)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)

        }
        
        task.resume()
        print(video)
        
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
