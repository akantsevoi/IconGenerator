//
//  File.swift
//  IconGenerator
//
//  Created by Alexandr on 2/18/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

struct IconItem: JSONSerializable {
    let size: CGFloat
    let idiom: String
    let scale: Int
    let role: String?
    let subtype: String?
    var filename: String?
    
    init(size: CGFloat, idiom: String, scale: Int, role: String? = nil, subtype: String? = nil, filename: String? = nil) {
        self.size = size
        self.idiom = idiom
        self.scale = scale
        self.role = role
        self.subtype = subtype
        self.filename = filename
    }
    
    init(json dict: [String: String]) {
        var newSize = 0.0
        if let sizeString = dict["size"] {
            newSize = Double(String(sizeString.characters.split{$0 == "x"}.first!))!
        }
        size = CGFloat(newSize)
        idiom = dict["idiom"]!
        
        var newScale = 1
        if let strinScale = dict["scale"] {
            newScale = Int(String(strinScale.characters.first!))!
        }
        scale = newScale
        
        role = dict["role"]
        subtype = dict["subtype"]
    }
    
    var JSONRepresentation: AnyObject {
        var representation = [String: String]()
        
        let strSize = sizeToString(size)
        
        representation["size"] = "\(strSize)x\(strSize)"
        representation["idiom"] = idiom
        representation["filename"] = filename
        representation["scale"] = String(scale) + "x"
        representation["role"] = role
        representation["subtype"] = subtype
        
        return representation as AnyObject
    }
    
    private func sizeToString(_ value: CGFloat) -> String {
        let (_, fract) = modf(Double(value))
        
        if fract > DBL_EPSILON {
            return String(format:"%.1f", value)
        } else {
            return String(format:"%.0f", value)
        }
    }
}

let templateItems = [
    IconItem.init(size: 20, idiom: "iphone", scale: 2),
    IconItem.init(size: 20, idiom: "iphone", scale: 3),
    IconItem.init(size: 29, idiom: "iphone", scale: 2),
    IconItem.init(size: 29, idiom: "iphone", scale: 3),
    IconItem.init(size: 40, idiom: "iphone", scale: 2),
    IconItem.init(size: 40, idiom: "iphone", scale: 3),
    IconItem.init(size: 60, idiom: "iphone", scale: 2),
    IconItem.init(size: 60, idiom: "iphone", scale: 3),
    IconItem.init(size: 20, idiom: "ipad", scale: 1),
    IconItem.init(size: 20, idiom: "ipad", scale: 2),
    IconItem.init(size: 29, idiom: "ipad", scale: 1),
    IconItem.init(size: 29, idiom: "ipad", scale: 2),
    IconItem.init(size: 40, idiom: "ipad", scale: 1),
    IconItem.init(size: 40, idiom: "ipad", scale: 2),
    IconItem.init(size: 76, idiom: "ipad", scale: 1),
    IconItem.init(size: 76, idiom: "ipad", scale: 2),
    IconItem.init(size: 83.5, idiom: "ipad", scale: 2),
    IconItem.init(size: 24, idiom: "watch", scale: 2, role: "notificationCenter", subtype: "38mm"),
    IconItem.init(size: 27.5, idiom: "watch", scale: 2, role: "notificationCenter", subtype: "42mm"),
    IconItem.init(size: 29, idiom: "watch", scale: 2, role: "companionSettings"),
    IconItem.init(size: 29, idiom: "watch", scale: 3, role: "companionSettings"),
    IconItem.init(size: 40, idiom: "watch", scale: 2, role: "appLauncher", subtype: "38mm"),
    IconItem.init(size: 86, idiom: "watch", scale: 2, role: "quickLook", subtype: "38mm"),
    IconItem.init(size: 98, idiom: "watch", scale: 2, role: "quickLook", subtype: "42mm"),
    IconItem.init(size: 16, idiom: "mac", scale: 1),
    IconItem.init(size: 16, idiom: "mac", scale: 2),
    IconItem.init(size: 32, idiom: "mac", scale: 1),
    IconItem.init(size: 32, idiom: "mac", scale: 2),
    IconItem.init(size: 128, idiom: "mac", scale: 1),
    IconItem.init(size: 128, idiom: "mac", scale: 2),
    IconItem.init(size: 256, idiom: "mac", scale: 1),
    IconItem.init(size: 256, idiom: "mac", scale: 2),
    IconItem.init(size: 512, idiom: "mac", scale: 1),
    IconItem.init(size: 512, idiom: "mac", scale: 2)
]
