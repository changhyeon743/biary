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
    func run(image: UIImage, completion:@escaping(JSON)->Void, progress: @escaping(Double)->Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("Error while converting image to jpeg")
            return
        }
        guard let to = URL(string: "\(API.base_url)/imageToText") else {
            return
        }
        
        AF.upload(multipartFormData: { (datas) in
            datas.append(imageData, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, to: to, usingThreshold: UInt64.init(), method: .post, headers: headers) .uploadProgress(queue: .main, closure: { pg in
            progress(pg.fractionCompleted)
        })
        .responseJSON(completionHandler: { data in
            //Do what ever you want to do with response
            completion(JSON(data.value))

        })
    }
}

