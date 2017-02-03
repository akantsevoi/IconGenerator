//
//  main.swift
//  IconGenerator
//
//  Created by Alexandr on 1/22/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation


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

let arguments = Array(lineArguments.dropFirst(2))

switch program {
    case .generator:
        let gen = Generator()
        gen.process(arguments)
    case .iconCutter:
        print("Unfinished")
}



