//
//  String.swift
//  biary
//
//  Created by 이창현 on 12/07/2019.
//  Copyright © 2019 이창현. All rights reserved.
//

import Foundation

extension String {
    var localized:String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
