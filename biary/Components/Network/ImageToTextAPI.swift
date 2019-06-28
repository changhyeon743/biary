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
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Error while converting image to jpeg")
            return
        }
        guard let to = URL(string: "\(API.base_url)/imageToText") else {
            return
        }
        
        
        Alamofire.upload(multipartFormData: { (datas) in
            datas.append(imageData, withName: "file", fileName: "file", mimeType: "image/jpeg")
        }, with: URLRequest(url: to) ) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    
                }
                upload.validate()
                upload.responseJSON { response in
                    completion(JSON(response))
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}
