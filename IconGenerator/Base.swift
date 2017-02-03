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
}
