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

let sizeIcon = 512

let versionDescription = "Version of your project"
let buildNumberDescription = "Build number of your project"
let colorDescription = "Background color for generated icon. \n\(tab)\(tab)Hexadecimal format without '#'. Example: -c 000000 \n\(tab)\(tab)Default - \(defaultColor)"
let hashDescription = "Hash of git commit"
let outputPathDescription = "Output path for Icon."

let outputIconName = "BaseIcon.png"

struct Generator: Submodule {
    func process(_ arguments: [String]) {
        
        self.baseCheckInput(arguments)
        
        let utiliteArguments = self.mapInputArguments(arguments)
        
        let version = self.checkRequiredInput(for: versionShortKey,
                                              in: utiliteArguments)
        let build = self.checkRequiredInput(for: buildShortKey,
                                            in: utiliteArguments)
        
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
                                  size: CGSize.init(width: sizeIcon, height: sizeIcon))
        
        let withText = writeText(onImage: image,
                                 textColor: opposit,
                                 versionNumber: "v: \(version)",
            bundleNumber: "b: \(build)",
            hashCommit: hashInput)
        
        var url = URL.init(fileURLWithPath: output)
        url.appendPathComponent(outputIconName)
        
        do {
            try withText.savePNGImage(at: url)
        } catch let error {
            print("\(error)")
            exit(EX_USAGE)
        }
    }
    
    func printHelp() {
        print("usage IconGenerator generator [options]:")
        printKeyDescription(for: colorShortKey,
                  description: colorDescription)
        printKeyDescription(for: versionShortKey,
                  description: versionDescription)
        printKeyDescription(for: buildShortKey,
                  description: buildNumberDescription)
        printKeyDescription(for: hashShortKey,
                  description: hashDescription)
        printKeyDescription(for: outputPathShortKey,
                  description: outputPathDescription)
    }
}
