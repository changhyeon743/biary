//
//  Internet.swift
//  biary
//
//  Created by 이창현 on 06/08/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
