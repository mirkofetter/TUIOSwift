//
//  Finger.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 28.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


class Finger{
    
    
    var  session_id:Int;
    
    
    static let  pi = Float.pi;
    private let halfPi = (Float)(Float.pi/2.0);
    private let doublePi = (Float)(Float.pi*2.0);
    
    
    var xspeed:Float;
    var yspeed:Float;
    var mspeed:Float;
    var maccel:Float;
    
    var path: [Point2D]
    private var lastTime:CLong;
    
    var windowWidth = 1920;
    var windowHeight = 1080;

    
    
    
    init(s_id:Int,  xpos:Int, ypos:Int) {
        
        self.session_id = s_id;
        
        path =  [Point2D]();
        path.append(Point2D(x: Float(xpos),y: Float(ypos)))
        
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0
        self.maccel = 0.0
        
        lastTime = TuioTime.getSystemTimeMillis()
    }
    
    
    func stop() {
        lastTime = TuioTime.getSystemTimeMillis();
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0
        self.maccel = 0.0
        
    }
    
    func update( xpos:Int, int ypos:Int) {
        
        var lastPoint = getPosition();
        path.append(Point2D(x: Float(xpos),y: Float(ypos)))
        
        // time difference in seconds
        let  currentTime = TuioTime.getSystemTimeMillis();
        let dt = Float(currentTime-lastTime)/1000.0;
        
        
        if (dt>0) {
            let dx = (Float(xpos) - lastPoint.x)/Float(windowWidth);
            let dy = (Float(ypos) - lastPoint.y)/Float(windowHeight);
            let dist = sqrt(dx*dx+dy*dy);
            let new_speed  = dist/dt;
            self.xspeed = dx/dt;
            self.yspeed = dy/dt;
            self.maccel = (new_speed-mspeed)/dt;
            self.mspeed = new_speed;
        } 
        lastTime = currentTime;
    }
    
    
    func getPosition() ->Point2D{
        return path.last!
    }
    
    
    func getPath() ->[Point2D] {
        return path;
    }
    
}
