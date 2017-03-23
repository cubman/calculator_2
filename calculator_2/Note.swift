//
//  Note.swift
//  calculator_2
//
//  Created by student on 22.03.17.
//  Copyright © 2017 com.sfedu.sinigr. All rights reserved.
//

//
//  Note.swift
//  notes-archive
//
//  Created by Илья Лошкарёв on 18.03.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation
import UIKit

class Note: NSObject, NSCoding {
    
    let content: String
    let res: String
    let color: UIColor

    
    init(content: String, result: String, color: UIColor = UIColor.red) {
        self.content = content
        self.res = result
        self.color = color
    }
    
    // MARK: NSCoding
    
    enum CodingKeys: String {
        case content, result, color
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let content = aDecoder.decodeObject(forKey: CodingKeys.content.rawValue) as? String
            else {
                return nil
        }
        
        guard
            let result = aDecoder.decodeObject(forKey: CodingKeys.result.rawValue) as? String
            else {
                return nil
        }
        
        if let color = aDecoder.decodeObject(forKey: CodingKeys.color.rawValue) as? UIColor {
            self.init(content: content, result: result, color: color)
        } else {
            self.init(content: content, result: result)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: CodingKeys.content.rawValue)
        aCoder.encode(content, forKey: CodingKeys.result.rawValue)
        aCoder.encode(color, forKey: CodingKeys.color.rawValue)
    }
    

}

