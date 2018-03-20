//
//  ViewController.swift
//  Example_GET
//
//  Created by Alexander Yakovenko on 3/19/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Thing {
    var image = #imageLiteral(resourceName: "Image")
    var name = "name"
    var price = 123
    var description: [String: Any] {
        get {
            return ["image": image, "name": name, "price": price] as [String: Any]
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = #imageLiteral(resourceName: "Image")
        let name = "name"
        let price = 123
        let thing = Thing()
        
        if let data = UIImageJPEGRepresentation(image, 1.0) {
           requestWith(endUrl: "", imageData: nil, parameters: [:], dataImage: data)
        }
    }
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], dataImage: Data, onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "http://192.168.0.110:3000/api/product/add" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multipartFormData.append(dataImage, withName: "image", fileName: "image.png", mimeType: "image/png")
            
            // name string to data
            let testString = "This"
            let somedata = testString.data(using: String.Encoding.utf8)
            //var backToString = String(data: somedata!, encoding: String.Encoding.utf8) as String!
            multipartFormData.append(somedata!, withName: "name") //somedata!
            
            //price to string to data
            let myInt = 77
            let dataInt = String(myInt)
            let somedata1 = dataInt.data(using: String.Encoding.utf8)
            multipartFormData.append(somedata1!, withName: "price")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}

