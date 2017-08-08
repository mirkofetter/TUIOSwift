//
//  main.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 23.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation



let client = TUIOClient(port: 3333);
let listener1 = MyListener()


client.addTuioListener(listener: listener1)



client.connect()

//client.addTuioListener(listener: myListener)

//let oscServer = F53OSCServer.init()
//oscServer.port=UInt16(3333)
//oscServer.delegate=TUIOClient(port: 3333);
//oscServer.startListening()


let oscClient = F53OSCClient.init()
oscClient.host = "127.0.0.1"
oscClient.port = 3332
let addressPattern = "/tuio/2Dcur"



for index in 1 ..< 1000 {
    
    
    var pos:Float = Float(100)/Float(50+index)
    
    let arguments = ["source", "osctest@10.0.1.3"];
    let message0 = F53OSCMessage(addressPattern: addressPattern, arguments: arguments)

    
    let arguments1 = ["alive", 1] as [Any]
    let message1 = F53OSCMessage(addressPattern: addressPattern, arguments: arguments1)

    let arguments2 = ["set", 1, pos, pos , 0.5,0.5, 0.5] as [Any]
    let message2 = F53OSCMessage(addressPattern: addressPattern, arguments: arguments2)

    
    let arguments3 = ["fseq", index] as [Any]
    let message3 = F53OSCMessage(addressPattern: addressPattern, arguments: arguments3)
    
    
    let elements: [Any] = [message0!.packetData(), message1!.packetData(),message2!.packetData(),message3!.packetData()]
    let bundle = F53OSCBundle(timeTag: F53OSCTimeTag.immediate(), elements: elements)
oscClient.send(bundle)
    
   print("Sent '\(bundle!)' to \(oscClient.host!):\(oscClient.port)")
    
    


}
