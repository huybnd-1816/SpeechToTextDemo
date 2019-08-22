//
//  CommonHelper.swift
//  STTDemo
//
//  Created by vu.hoang.anh on 8/22/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

class CommonHelper: NSObject {

}

func delay(_ delay:Double, closure: @escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when) {
        closure()
    }
}
