//
//  exceptions.swift
//  calculator_2
//
//  Created by student on 21.03.17.
//  Copyright © 2017 com.sfedu.sinigr. All rights reserved.
//

import Foundation

enum MyErrors : Error {
    case divideByZero(String)
    case tooLongNumb(String)
    case negativeNumber(String)
}
