//
//  main.swift
//  IconGenerator
//
//  Created by Alexandr on 1/22/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

let colorShortKey = "-c"
let versionShortKey = "-v"
let buildShortKey = "-b"
let outputPathShortKey = "-p"

let helpShortKey = "-h"
let helpFullKey = "help"

let defaultColor = "#000000"

let tab = "    "

let lineArguments = CommandLine.arguments

func printHelp(for key: String, description: String) {
    print("\(tab)\(key):")
    print("\(tab)\(tab)\(description)")
}

func printHelpInfo () {
    print("usage IconGenerator [options]:")
    printHelp(for: colorShortKey,
              description: "Background color for generated icon. Default - \(defaultColor)")
    printHelp(for: versionShortKey,
              description: "Version of your project")
    printHelp(for: buildShortKey,
              description: "Build number of your project")
    printHelp(for: outputPathShortKey,
              description: "Output path for Icon.")
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

guard let output = arguments[outputPathShortKey] else {
    print("\(outputPathShortKey) is recquired param")
    exit(EX_USAGE)
}

let color = arguments[colorShortKey] ?? defaultColor
