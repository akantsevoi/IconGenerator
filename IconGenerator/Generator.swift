//
//  Generator.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

let colorShortKey = "-c"
let versionShortKey = "-v"
let buildShortKey = "-b"
let outputPathShortKey = "-p"
let hashShortKey = "-g"

let defaultColor = "000000"

let versionDescription = "Version of your project"
let buildNumberDescription = "Build number of your project"
let colorDescription = "Background color for generated icon. \n\(tab)\(tab)Hexadecimal format without '#'. Example: -c 000000 \n\(tab)\(tab)Default - \(defaultColor)"
let hashDescription = "Hash of git commit"
let outputPathDescription = "Output path for Icon."

let outputIconName = "BaseIcon.png"

struct Generator: Submodule {
    func process(_ arguments: [String : String]) {
        
        
        guard let version = arguments[versionShortKey] else {
            print("\(versionShortKey) is recquired param")
            exit(EX_USAGE)
        }
        
        guard let build = arguments[buildShortKey] else {
            print("\(buildShortKey) is recquired param")
            exit(EX_USAGE)
        }
        
        var hashInput = arguments[hashShortKey]
        if let hash = hashInput {
            hashInput = "#: " + hash
        }
        
        let output = arguments[outputPathShortKey] ?? "./"
        let color = "#" + (arguments[colorShortKey] ?? defaultColor)
        
        
        
        
        guard let inputColor = getColorFromString(hex: color) else {
            print("Incorrect color value: \(color)")
            exit(EX_USAGE)
        }
        
        let opposit = contrastColor(to: inputColor)
        
        let image = generateImage(color: inputColor,
                                  size: CGSize.init(width: 180, height: 180))
        
        let withText = writeText(onImage: image,
                                 textColor: opposit,
                                 versionNumber: "v: \(version)",
            bundleNumber: "b: \(build)",
            hashCommit: hashInput)
        
        let ref = withText.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let newRep = NSBitmapImageRep.init(cgImage: ref!)
        newRep.size = withText.size
        let pngData = newRep.representation(using: NSPNGFileType, properties: [String : Any]())
        
        var url = URL.init(fileURLWithPath: output)
        url.appendPathComponent(outputIconName)
        
        do {
            try pngData?.write(to:url)
        } catch let error {
            print("\(error)")
            exit(EX_USAGE)
        }
    }
    
    private func helpString(for key: String, description: String) -> String {
        return "\(tab)\(key):\n\(tab)\(tab)\(description)"
    }
    
    func help() -> String {
        var help = ""
        help += "usage IconGenerator generator [options]:"
        help += helpString(for: colorShortKey,
                  description: colorDescription)
        help += helpString(for: versionShortKey,
                  description: versionDescription)
        help += helpString(for: buildShortKey,
                  description: buildNumberDescription)
        help += helpString(for: hashShortKey,
                  description: hashDescription)
        help += helpString(for: outputPathShortKey,
                  description: outputPathDescription)
        return help
    }
}
