//
//  Base.swift
//  IconGenerator
//
//  Created by Alexandr on 1/28/17.
//  Copyright © 2017 Aliaksandr Kantsevoi. All rights reserved.
//

import Foundation

let tab = "    "


protocol Submodule {
    func process(_ arguments: [String:String])
    func help() -> String
}
