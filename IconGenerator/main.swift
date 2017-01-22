//
//  main.swift
//  IconGenerator
//
//  Created by Alexandr on 1/22/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import CommandLineKit


let cli = CommandLineKit.CommandLine()

let versionNumber = StringOption(shortFlag: "v",
                                 longFlag: "versionNumber",
                                 required: true,
                                 helpMessage: "String version of project for generate icon")

let buildNumber = StringOption(shortFlag: "b",
                               longFlag: "buildNumber",
                               required: true,
                               helpMessage: "String build number of project for generate icon")

let color = StringOption(shortFlag: "c",
                         longFlag: "color",
                         required: false,
                         helpMessage: "Background color for icon. Hexadecimal format. #000000 - default")

cli.addOptions(versionNumber,
               buildNumber,
               color)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

print("v: \(versionNumber.value)")
print("b: \(buildNumber.value)")
print("c: \(color.value)")
