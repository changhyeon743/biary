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
        
        Alamofire.upload(multipartFormData: { (datas) in
            datas.append(imageData, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
        }, usingThreshold: UInt64.init(), to: to, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { pg in
                    print(pg.fractionCompleted)
                    progress(pg.fractionCompleted)
                }
                upload.validate()
                upload.responseJSON { response in
                    completion(JSON(response.result.value))
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}

