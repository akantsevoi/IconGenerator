//
//  main.swift
//  IconGenerator
//
//  Created by Alexandr on 1/22/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

let colorShortKey = "-c"
let versionShortKey = "-v"
let buildShortKey = "-b"
let outputPathShortKey = "-p"
let hashShortKey = "-g"

let helpShortKey = "-h"
let helpFullKey = "help"

let defaultColor = "000000"

let tab = "    "


let versionDescription = "Version of your project"
let buildNumberDescription = "Build number of your project"
let colorDescription = "Background color for generated icon. \n\(tab)\(tab)Hexadecimal format without '#'. Example: -c 000000 \n\(tab)\(tab)Default - \(defaultColor)"
let hashDescription = "Hash of git commit"
let outputPathDescription = "Output path for Icon."

let outputIconName = "BaseIcon.png"


let lineArguments = CommandLine.arguments

func printHelp(for key: String, description: String) {
    print("\(tab)\(key):")
    print("\(tab)\(tab)\(description)")
}

func printHelpInfo () {
    print("usage IconGenerator [options]:")
    printHelp(for: colorShortKey,
              description: colorDescription)
    printHelp(for: versionShortKey,
              description: versionDescription)
    printHelp(for: buildShortKey,
              description: buildNumberDescription)
    printHelp(for: hashShortKey,
              description: hashDescription)
    printHelp(for: outputPathShortKey,
              description: outputPathDescription)
}

guard lineArguments.count > 1 else {
    printHelpInfo()
    exit(EX_OK)
}

guard lineArguments[1] != helpFullKey,
    lineArguments[1] != helpShortKey else {
    printHelpInfo()
    exit(EX_OK)
}

var arguments = [String:String]()


for i in stride(from:1, to:lineArguments.count, by: 2) {
    arguments[lineArguments[i]] = lineArguments[i+1]
}

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

try pngData?.write(to:url)
