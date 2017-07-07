//
//  Functions.swift
//  IconGenerator
//
//  Created by Alexandr on 1/23/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

fileprivate let fontProportion: CGFloat = 6

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
                      topText:String?,
                      midText:String?,
                      bottomText:String?) -> NSImage {
    
    let sizeImage = image.size
    let height = sizeImage.height
    
    if let topText = topText {
        image.drawText(topText,
                       in: NSRect.init(x: 0, y: height * 2 / 3 - 20, width: sizeImage.width, height: height / 3),
                       textColor: textColor, halfSized: true)
    }
    
    if let midText = midText {
        image.drawText(midText,
                       in: NSRect.init(x: 0, y: height / 4 + 20, width: sizeImage.width, height: height / 6),
                       textColor: textColor)
    }
    
    if let bottomText = bottomText {
        image.drawText(bottomText,
                       in: NSRect.init(x: 0, y: 10, width: sizeImage.width, height: height / 6),
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
                         in rect: NSRect,
                         textColor: NSColor = NSColor.white,
                         halfSized: Bool = false) {
        let fontSize = halfSized ? (rect.size.height / 2) - 30 : rect.size.height
        let textFont = NSFont.systemFont(ofSize: fontSize)
        
        let styleCenter = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        styleCenter.alignment = NSCenterTextAlignment
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: styleCenter
            ] as [String : Any]
        
        
        self.lockFocus()
        let str:NSString = NSString.init(string: text)
        str.draw(in: rect, withAttributes: textFontAttributes)
        
        self.unlockFocus()
    }
    
    public func savePNGImage(at path: URL) throws {
        let ref = self.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let newRep = NSBitmapImageRep.init(cgImage: ref!)
        newRep.size = self.size
        let pngData = newRep.representation(using: NSPNGFileType, properties: [:])
        
        try pngData?.write(to: path)
    }
    
    public func saveImage(withSize size: NSSize, at path: URL) {
        
        let originalSize = self.size
        
        let resizedImage = NSImage.init(size: size)
        resizedImage.lockFocus()
        self.draw(in: NSRect.init(x: 0, y: 0, width: size.width, height: size.height),
                  from: NSRect(x: 0, y: 0, width: originalSize.width, height: originalSize.height),
                  operation: .sourceOver,
                  fraction: 1.0)
        resizedImage.unlockFocus()
        
        do {
            try resizedImage.savePNGImage(at: path)
        } catch {}
    }
}
