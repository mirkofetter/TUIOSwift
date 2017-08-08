//
//  Manager.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 28.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


public class Manager {
    
    
    private let  negPi = Float.pi * -1.0;
    private let  posPi = Float.pi;
    private let halfPi = (Float)(Float.pi/2.0);
    private let doublePi = (Float)(Float.pi*2.0);
    
    var verbose:Bool = false;
    var antialiasing:Bool = true;
    var collision:Bool = false;
    
    var invertx:Bool = false;
    var inverty:Bool = false;
    var inverta:Bool = false;
    
    var objectList = [Int: Tangible]()
    var cursorList = [Int: Finger]()
    
    func readConfig(){
        
        
    }
    
    func  reset() {
        cursorList.removeAll()
        objectList.removeAll();
        readConfig();
    }
    
    func activateObject( old_id:Int,  session_id:Int) {
        
        
        let tangible:Tangible = objectList[old_id]!
        
        if(!tangible.isActive()) {
            if (verbose) {
                print("add obj \(session_id) \(tangible.fiducial_id)");
                
            }
        }
        
        tangible.activate(s_id: session_id);
        objectList.removeValue(forKey: old_id)
        objectList[session_id] = tangible;
        
    }
    
    
    func deactivateObject( tangible:Tangible) {
        
        if(tangible.isActive()) {
            if (verbose) {
                print("del obj \(tangible.session_id) \(tangible.fiducial_id)");
            }
        }
        tangible.deactivate();
        
    }
    
    
    func updateObject( tangible:Tangible,  x:Int,  y:Int,  a:Float) {
        let  pt =  tangible.getPosition();
        let dx = Float(x)-pt.x;
        let dy = Float(y)-pt.y;
        var dt = a - tangible.getAngle();
        
        if (dt < negPi) {
            dt += doublePi;
        }
        if (dt > posPi) {
            dt -= doublePi;
        }
        
        if (!(dx==0) || !(dy==0)) {
            tangible.translate(dx: dx,dy: dy);
        }
        if (!(dt==0)) {
            tangible.rotate(theta: Double(dt));
        }
    }
    
    func addCursor( s_id:Int,  x:Int,  y:Int) -> Finger{
        
        let cursor =  Finger(s_id: s_id,xpos: x,ypos: y);
        
        cursorList[s_id]=cursor;
        return cursor;
    }
    
    func updateCursor( cursor:Finger,   x:Int,  y:Int) {
        
        cursor.update(xpos: x,int: y);
    }
    
    func  getCursor( s_id:Int)->Finger {
        return cursorList[s_id]!;
    }
    
    func terminateCursor( cursor:Finger) {
        cursorList.removeValue(forKey:cursor.session_id);
    }
}


