//
//  Functions.swift
//  IconGenerator
//
//  Created by Alexandr on 1/23/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa


public func generateImage (color: NSColor,
                           size: NSSize = NSSize(width: 1, height: 1)) -> NSImage {
    let image = NSImage.init(size: size)
    image.lockFocus()
    color.drawSwatch(in: NSRect.init(origin: CGPoint.zero, size: size))
    image.unlockFocus()
    return image
}


public func contrastColor(to color: NSColor) -> NSColor {
    
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    
    if let components = color.cgColor.components {
        
        if components[0] < 0.5 {
            r = 1
        }
        
        if components[1] < 0.5 {
            g = 1
        }
        
        if components[2] < 0.5 {
            b = 1
        }
        
        
        return NSColor.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    return NSColor.blue
}


public func writeText(onImage image: NSImage,
                      textColor: NSColor = NSColor.white,
                      versionNumber:String,
                      bundleNumber:String,
                      hashCommit:String?) -> NSImage {
    
    image.drawText(versionNumber,
                   atPoint: CGPoint.init(x: 0, y: 180-40),
                   textColor: textColor)
    
    image.drawText(bundleNumber,
                   atPoint: CGPoint.init(x: 0, y: 70),
                   textColor: textColor)
    
    if let hash = hashCommit {
        image.drawText(hash,
                       atPoint: CGPoint.init(x: 0, y: 0),
                       textColor: textColor)
    }
    
    return image
}


func getColorFromString(hex hexColorString : String) -> NSColor?
{
    var result : NSColor? = nil
    var colorCode : UInt32 = 0
    var redByte, greenByte, blueByte : UInt8
    
    let index = hexColorString.index(hexColorString.startIndex, offsetBy: 1)
    let substring1 = hexColorString.substring(from: index)
    
    let scanner = Scanner(string: substring1)
    let success = scanner.scanHexInt32(&colorCode)
    
    if success == true {
        redByte = UInt8.init(truncatingBitPattern: (colorCode >> 16))
        greenByte = UInt8.init(truncatingBitPattern: (colorCode >> 8))
        blueByte = UInt8.init(truncatingBitPattern: colorCode) // masks off high bits
        
        result = NSColor(calibratedRed: CGFloat(redByte) / 0xff, green: CGFloat(greenByte) / 0xff, blue: CGFloat(blueByte) / 0xff, alpha: 1.0)
    }
    return result
}

extension NSImage {
    public func drawText(_ text: String,
                         atPoint point: NSPoint,
                         textColor: NSColor = NSColor.white){
        
        let textFont = NSFont(name: "Helvetica Bold", size: 30)!
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        
        self.lockFocus()
        let str:NSString = NSString.init(string: text)
        str.draw(at: point,
                 withAttributes: textFontAttributes)
        
        
        self.unlockFocus()
    }
}
