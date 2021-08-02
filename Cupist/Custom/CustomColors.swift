//
//  CustomColors.swift
//  Cupist
//
//  Created by joon-ho kil on 2020/03/28.
//  Copyright © 2020 joon-ho kil. All rights reserved.
//

import Foundation
import UIKit

enum CustomColor {
    case cupistGrey
    case cupistPink
}

extension CustomColor {
    var value: UIColor {
        get {
            switch self {
            case .cupistGrey:
                return UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
            case .cupistPink:
                return UIColor(red: 234/255, green: 52/255, blue: 109/255, alpha: 1.0)
            }
        }
    }
}
