//
//  TUIOServer.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 28.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation

class TUIOServer {
    
    
    private let oscClient:F53OSCClient
    
    
    private var currentFrame = 0;
    private var lastFrameTime = -1;
    private var session_id = -1;
    
    var lastX  = -1;
    var lastY  = -1;
    var clickX = 0;
    var clickY = 0;
    
    var windowWidth = 1920;
    var windowHeight = 1080;
    
    
    var table_width:Int
    var table_height:Int
    var border_width:Int
    var border_height:Int
    
    static let  pi = Float.pi;
    private let halfPi = (Float)(Float.pi/2.0);
    private let doublePi = (Float)(Float.pi*2.0);
    
    var sourceString:String;
    
    var selectedObject:Tangible?;
    var selectedCursor:Finger?;

    
    init(){
        oscClient = F53OSCClient.init()
        oscClient.host = "127.0.0.1"
        oscClient.port = 3333
        
         table_width = (Int)(Float(windowWidth)/1.25);
         table_height = (Int)(Float(windowHeight)/1.25);
         border_width = (Int)(windowWidth)/2;
         border_height = (Int)(windowHeight-table_height)/2;
        sourceString = "tuioSift@" + Host.current().address!;

        
    }
    
    private func sendOSC(bundle:F53OSCBundle) {
        oscClient.send(bundle)
    }
    
    
    private func  setMessage( tangible:Tangible) -> F53OSCMessage{
        
        
        let xpos = Float(tangible.getPosition().x - Float(border_width)/Float(table_width));
        let ypos = Float(tangible.getPosition().y - Float(border_height)/Float(table_height));
        var angle = tangible.getAngle() - Float.pi;
        
        if (angle<0) {
            angle += doublePi
        }
        
        var arguments = ["set"] as [Any]
        arguments.append(tangible.session_id);
        arguments.append(tangible.fiducial_id);
        arguments.append(xpos);
        arguments.append(ypos);
        arguments.append(angle);
        arguments.append(tangible.xspeed);
        arguments.append(tangible.yspeed);
        arguments.append(tangible.rspeed);
        arguments.append(tangible.maccel);
        arguments.append(tangible.raccel);
        
        let setMessage = F53OSCMessage(addressPattern: "/tuio/2Dobj", arguments: arguments)
        
        return setMessage!;
    }
    
    
    private func cursorDelete() {
    
       
        
        let sourceArguments = ["source", sourceString];
        let sourceMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: sourceArguments)

  
        let aliveArguments = ["alive"];
//        Enumeration<Integer> cursorList = manager.cursorList.keys();
//        while (cursorList.hasMoreElements()) {
//            Integer s_id = cursorList.nextElement();
//            aliveArguments.append(s_id);
//        }
        
        let aliveMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: aliveArguments)

 
        currentFrame += 1;
        
        let frameArguments = ["fseq", currentFrame] as [Any];
        let frameMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: frameArguments)

        
        let elements: [Any] = [sourceMessage!.packetData(),aliveMessage!.packetData(),frameMessage!.packetData()]
        
        let cursorBundle = F53OSCBundle(timeTag: F53OSCTimeTag.immediate(), elements: elements)
        oscClient.send(cursorBundle)
        
        }
    
    
    private func cursorMessage() {
        

        
        
        let sourceArguments = ["source", sourceString];
        let sourceMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: sourceArguments)

        let aliveArguments = ["alive"];
        //        Enumeration<Integer> cursorList = manager.cursorList.keys();
        //        while (cursorList.hasMoreElements()) {
        //            Integer s_id = cursorList.nextElement();
        //            aliveArguments.append(s_id);
        //        }
        
        let aliveMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: aliveArguments)

        
        let cursor = selectedCursor;
        let point = cursor?.getPosition();
//    float xpos = (point.x-border_width)/(float)table_width;
//    if (manager.invertx) xpos = 1 - xpos;
//    float ypos = (point.y-border_height)/(float)table_height;
//    if (manager.inverty) ypos = 1 - ypos;
//    OSCMessage setMessage = new OSCMessage("/tuio/2Dcur");
//    setMessage.addArgument("set");
//    setMessage.addArgument(cursor.session_id);
//    setMessage.addArgument(xpos);
//    setMessage.addArgument(ypos);
//    setMessage.addArgument(cursor.xspeed);
//    setMessage.addArgument(cursor.yspeed);
//    setMessage.addArgument(cursor.maccel);
        
        
   var setArguments = ["set"] as [Any]
//        setArguments.append(cursor.session_id);
//        setArguments.append(xpos);
//        setArguments.append(ypos);
//        setArguments.append(cursor.xspeed);
//       setArguments.append(cursor.yspeed);
//        setArguments.append(cursor.maccel);
        
        
        let setMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: setArguments)

        
        currentFrame += 1;
        
        let frameArguments = ["fseq", currentFrame] as [Any];
        let frameMessage = F53OSCMessage(addressPattern: "/tuio/2Dcur", arguments: frameArguments)
    
 
//    if (manager.verbose) {
//    System.out.println("set cur "+cursor.session_id+" "+xpos+" "+ypos+" "+cursor.xspeed+" "+cursor.yspeed+" "+cursor.maccel);
//    }
        
        let elements: [Any] = [sourceMessage!.packetData(),aliveMessage!.packetData(),setMessage!.packetData(),frameMessage!.packetData()]
        
        let cursorBundle = F53OSCBundle(timeTag: F53OSCTimeTag.immediate(), elements: elements)
        oscClient.send(cursorBundle)    }
    
}
