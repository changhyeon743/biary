//
//  ImageToTextAPI.swift
//  biary
//
//  Created by 이창현 on 28/06/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ImageToTextAPI {
    func run(image: UIImage, profileURL: String, token: String,completion:@escaping(JSON)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "name" : name,
            "facebookId" : facebookId,
            "profileURL" : profileURL,
            "token" : token
        ]
        
       Alamofire.upload(<#T##data: Data##Data#>, to: <#T##URLConvertible#>) Alamofire.request("\(API.base_url)/auth/register",method:.post,parameters:parameters,encoding:URLEncoding.httpBody,headers:headers)
            .responseJSON(completionHandler: { (response) in
                //1. JSON 변환
                if let value = response.result.value,response.result.isSuccess {
                    completion(JSON(value))
                }
            })
    }
}
