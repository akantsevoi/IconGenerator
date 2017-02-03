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
    func process(_ arguments: [String]) {
        
        if let firstArgument = arguments.first,
            firstArgument == helpShortKey ||
                firstArgument == helpFullKey {
            self.printHelp()
            exit(EX_OK)
        }
        
        if arguments.count % 2 == 1 {
            self.printHelp()
            exit(EX_USAGE)
        }
        
        var utiliteArguments = [String: String]()
        
        for i in stride(from: 0, to: arguments.count, by: 2) {
            utiliteArguments[arguments[i]] = arguments[i + 1]
        }
        
        guard let version = utiliteArguments[versionShortKey] else {
            print("\(versionShortKey) is recquired param")
            exit(EX_USAGE)
        }
        
        guard let build = utiliteArguments[buildShortKey] else {
            print("\(buildShortKey) is recquired param")
            exit(EX_USAGE)
        }
        
        var hashInput = utiliteArguments[hashShortKey]
        if let hash = hashInput {
            hashInput = "#: " + hash
        }
        
        let output = utiliteArguments[outputPathShortKey] ?? "./"
        let color = "#" + (utiliteArguments[colorShortKey] ?? defaultColor)
        
        
        
        
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
    
    private func printPartHelpString(for key: String, description: String) {
        print("\(tab)\(key):")
        print("\(tab)\(tab)\(description)")
    }
    
    func printHelp() {
        print("usage IconGenerator generator [options]:")
        printPartHelpString(for: colorShortKey,
                  description: colorDescription)
        printPartHelpString(for: versionShortKey,
                  description: versionDescription)
        printPartHelpString(for: buildShortKey,
                  description: buildNumberDescription)
        printPartHelpString(for: hashShortKey,
                  description: hashDescription)
        printPartHelpString(for: outputPathShortKey,
                  description: outputPathDescription)
    }
}
