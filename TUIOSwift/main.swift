//
//  main.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 23.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


let oscClient = F53OSCClient.init()
oscClient.host = "127.0.0.1"
oscClient.port = 3000

let message = F53OSCMessage(addressPattern: "/hello", arguments: [0, 1, 2])
oscClient.sendPacket(message)

print("Sent '\(message)' to \(oscClient.host):\(oscClient.port)")
