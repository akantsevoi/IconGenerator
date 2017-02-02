//
//  main.swift
//  IconGenerator
//
//  Created by Alexandr on 1/22/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation



let helpShortKey = "-h"
let helpFullKey = "help"

enum Programs:String {
    case generator
    case iconCutter
}

let lineArguments = CommandLine.arguments

func printHelpInfo () {
    print("IconGenerator:")
    print("\(tab)\(Programs.generator.rawValue)")
    print("\(tab)\(Programs.iconCutter.rawValue)")
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



guard let program = Programs.init(rawValue: lineArguments[1]) else {
    print("\(lineArguments[1]) doesn't support")
    printHelpInfo()
    exit(EX_OK)
}

guard lineArguments.count % 2 == 0 else {
    print("Input error")
    printHelpInfo()
    exit(EX_OK)
}

var arguments = [String:String]()

for i in stride(from:2, to:lineArguments.count, by: 2) {
    arguments[lineArguments[i]] = lineArguments[i+1]
}

let gen = Generator()

