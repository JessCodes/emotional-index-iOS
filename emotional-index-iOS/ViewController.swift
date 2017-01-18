//
//  ViewController.swift
//  emotional-index-iOS
//
//  Created by Jessica Ellison on 1/13/17.
//  Copyright © 2017 tokatlystantilizers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared    

   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var faceResults: UITextView!
    
    let googleAPIKey = valueForAPIKey(named:"GEMO_KEY")
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
  @IBAction func twilio(_ sender: Any) {
//    let scriptUrl = "https://emotemetoo.herokuapp.com/twilio"
      let scriptUrl = "http://localhost:3000/twilio"
    
      let keychain = Keychain(service: "com.tokatlys-tantilizers.emotional-index-iOS")
      let twilioText = keychain[string: "user"]!
    
    // Add one parameter
    let urlWithParams = scriptUrl + "?id=\(twilioText)"
    
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

    }
    
    task.resume()

  }

    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
      
        present(imagePicker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        faceResults.isHidden = true
        spinner.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/// Image processing

extension ViewController {
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            self.spinner.stopAnimating()
            self.imageView.isHidden = false
            self.faceResults.isHidden = false
            self.imageButton.isHidden = true
            self.faceResults.text = ""
            
            if (errorObj.dictionaryValue != [:]) {
                self.faceResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                let responses: JSON = json["responses"][0]
                
                let faceAnnotations: JSON = responses["faceAnnotations"]
                if faceAnnotations != JSON.null {
                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
                    
                    let numPeopleDetected:Int = faceAnnotations.count
                    
                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
                    
                    
                    for index in 0..<numPeopleDetected {
                        let personData:JSON = faceAnnotations[index]
                        
                        // Sum all the detected emotions
                        for emotion in emotions {
                            let lookup = emotion + "Likelihood"
                            let result:String = personData[lookup].stringValue
                            emotionTotals[emotion]! += emotionLikelihoods[result]!
                        }
                        
                    }
                    let scriptUrl = "http://localhost:3000/gemo"
                    let keychain = Keychain(service: "com.tokatlys-tantilizers.emotional-index-iOS")

                    for (emotion, total) in emotionTotals {
                        if total == emotionTotals.values.max()
                        {
                            if emotion == "joy" {
                                self.faceResults.text! = "you look like you're feeling joy"

                                var urlWithParams = scriptUrl + "?id=\(keychain[string: "user"]!)&emotion=\(emotion)"
                                var myUrl = NSURL(string: urlWithParams);
                                var request = NSMutableURLRequest(url:myUrl as! URL);

                                request.httpMethod = "GET"
                               
                                var task = URLSession.shared.dataTask(with: request as URLRequest) {
                                    data, response, error in
                                    
                                    // Check for error
                                    if error != nil
                                    {
                                        print("error=\(error)")
                                        return
                                    }
                                    
                                    // Print out response string
                                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                    print("responseString = \(responseString)")

                                print(keychain[string: "user"]!)
                                }
                            task.resume()

                            }
                            else if emotion == "anger"
                            {
                                self.faceResults.text! = "you look like you're feeling angry"
                                
                                var urlWithParams = scriptUrl + "?id=\(keychain[string: "user"]!)&emotion=\(emotion)"
                                var myUrl = NSURL(string: urlWithParams);
                                var request = NSMutableURLRequest(url:myUrl as! URL);
                                
                                request.httpMethod = "GET"
                                
                                var task = URLSession.shared.dataTask(with: request as URLRequest) {
                                    data, response, error in
                                    
                                    // Check for error
                                    if error != nil
                                    {
                                        print("error=\(error)")
                                        return
                                    }
                                    
                                    // Print out response string
                                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                    print("responseString = \(responseString)")
                                    
                                }
                                task.resume()

                            }
                            else if emotion == "surprise"
                            {
                                self.faceResults.text! = "you look surprised!"
                                
                                var urlWithParams = scriptUrl + "?id=\(keychain[string: "user"]!)&emotion=\(emotion)"
                                var myUrl = NSURL(string: urlWithParams);
                                var request = NSMutableURLRequest(url:myUrl as! URL);
                                
                                request.httpMethod = "GET"

                                var task = URLSession.shared.dataTask(with: request as URLRequest) {
                                    data, response, error in
                                    
                                    // Check for error
                                    if error != nil
                                    {
                                        print("error=\(error)")
                                        return
                                    }
                                    
                                    // Print out response string
                                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                    print("responseString = \(responseString)")
                                    
                                }
                                task.resume()

                            }
                            else if emotion == "sorrow"
                            {
                                self.faceResults.text! = "you look like you're feeling sorrow"
                                
                                var urlWithParams = scriptUrl + "?id=\(keychain[string: "user"]!)&emotion=\(emotion)"
                                var myUrl = NSURL(string: urlWithParams);
                                var request = NSMutableURLRequest(url:myUrl as! URL);
                                
                                request.httpMethod = "GET"
                                
                                var task = URLSession.shared.dataTask(with: request as URLRequest) {
                                    data, response, error in
                                    
                                    // Check for error
                                    if error != nil
                                    {
                                        print("error=\(error)")
                                        return
                                    }
                                    
                                    // Print out response string
                                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                    print("responseString = \(responseString)")
                                    
                                }
                                task.resume()
                                
                            }
                            else {
                                self.faceResults.text! = "something went wrong"
                            }
                        }
                        
                    }
                } else {
                    self.faceResults.text = "No faces found"
                }
            }
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            spinner.startAnimating()
            faceResults.isHidden = false
            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}


/// Networking

extension ViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        
        request.httpBody = data
        
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self.analyzeResults(data)
        }
        
        task.resume()
    }
}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
