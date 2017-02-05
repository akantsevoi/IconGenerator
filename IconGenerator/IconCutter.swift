//
//  IconCutter.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation
import Cocoa

let baseIconPathKey = "-p"
let configPathKey = "-c"



struct IconCutter: Submodule {
    func process(_ arguments: [String]) {
        self.baseCheckInput(arguments)
        
        let utiliteArguments = self.mapInputArguments(arguments)
        
        let baseIconUrl = self.checkRequiredInput(for: baseIconPathKey,
                                                  in: utiliteArguments)
        
        
        guard let configPath = utiliteArguments[configPathKey] ??
            Bundle.main.path(forResource: "template", ofType: "json") else {
                print("Incorrect template url")
                exit(EX_USAGE)
        }
        
        guard let image = NSImage.init(contentsOfFile: baseIconUrl) else {
            print("Cannot open image")
            exit(EX_USAGE)
        }
        
        let jsonURL = URL.init(fileURLWithPath: configPath)
        
        guard let configData = try? Data.init(contentsOf: jsonURL) else {
            print("Error read config file")
            exit(EX_USAGE)
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: configData, options: []) else {
            print("Error deserialization config file")
            exit(EX_USAGE)
        }
        
        guard let configValues = json as? [String: Any] else {
            print("Error parse config file")
            exit(EX_USAGE)
        }
        
        print("\(configValues)\n\n")
        print("\(type(of: configValues))")
    }
    
    func printHelp() {
        print("usage IconGenerator iconCutter [options]:")
    }
}
