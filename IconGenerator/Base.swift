//
//  Base.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

let tab = "    "

let helpShortKey = "-h"
let helpFullKey = "help"

protocol Submodule {
    func process(_ arguments: [String])
    func baseCheckInput(_ arguments: [String])
    func printHelp()
    func printKeyDescription(for key: String, description: String)
    func checkRequiredInput(for key: String, in arguments: [String: String]) -> String
    func mapInputArguments(_ arguments: [String]) -> [String: String]
}

extension Submodule {
    func baseCheckInput(_ arguments: [String]) {
        if let firstArgument = arguments.first,
            firstArgument == helpShortKey ||
                firstArgument == helpFullKey {
            self.printHelp()
            exit(EX_OK)
        }
        
        if arguments.count == 0 || arguments.count % 2 == 1 {
            self.printHelp()
            exit(EX_USAGE)
        }
    }
    
    func printKeyDescription(for key: String, description: String) {
        print("\(tab)\(key):")
        print("\(tab)\(tab)\(description)")
    }
    
    func checkRequiredInput(for key: String, in arguments: [String: String]) -> String {
        guard let value = arguments[key] else {
            print("\(key) is required param")
            exit(EX_USAGE)
        }
        
        return value
    }
    
    func mapInputArguments(_ arguments: [String]) -> [String: String] {
        var utiliteArguments = [String: String]()
        
        for i in stride(from: 0, to: arguments.count, by: 2) {
            utiliteArguments[arguments[i]] = arguments[i + 1]
        }
        
        return utiliteArguments
    }
}
