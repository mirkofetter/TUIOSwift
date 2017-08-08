//
//  Tangible.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 28.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation

class Tangible {
    
    var  fiducial_id:Int;
    var  session_id:Int;
    // public  type:TangibleType;
    
    //    public Shape geom;
    var center:Point2D;
    //    public Color color;
    
    private var active:Bool;
    var pushed:Bool = false;
    var orientation:Float = 0.0;
    
    static let  pi = Float.pi;
    private let halfPi = (Float)(Float.pi/2.0);
    private let doublePi = (Float)(Float.pi*2.0);
    
    
    var xspeed:Float;
    var yspeed:Float;
    var mspeed:Float;
    var maccel:Float;
    var rspeed:Float;
    var raccel:Float;
    
    var windowWidth = 1920;
    var windowHeight = 1080;
    
    var  previous:Tangible?;
    var Tangible:Tangible?;
    
    private var lastTime:CLong;
    
    init(s_id:Int,  f_id:Int,  active:Bool,  xpos:Float, ypos:Float,  angle:Float) {
        
        
        self.session_id = s_id;
        self.fiducial_id = f_id;
        //self.type = type;
        self.active = active;
        
        self.center = Point2D(x: 0.0,y: 0.0);
        
        let dx = xpos - center.getX();
        let dy = ypos - center.getY();
        
        let dr = angle;
        
        
        self.lastTime = TuioTime.getSystemTimeMillis() //Nano not Milli
        
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0;
        self.rspeed = 0.0;
        self.maccel = 0.0;
        self.raccel = 0.0;
        
        translate(dx: dx,dy: dy);
        rotate(theta: Double(dr - orientation));
    }
    
    
    func   translate( dx:Float,  dy:Float) {
        
        
        
        //     var trans = CGAffineTransform (translationX: CGFloat(dx), y: CGFloat(dy))
        //    AffineTransform trans = AffineTransform.getTranslateInstance(dx,dy);
        //    geom = trans.createTransformedShape(geom);
        //    center = new Point2D.Float((float)(center.getX()+dx),(float)(center.getY()+dy));
        
        
        // normalized distances
        let nx = dx/Float(windowWidth);
        let ny = dy/Float(windowHeight);
        //
        //    // time difference in seconds
        let  currentTime = TuioTime.getSystemTimeMillis();
        let dt = Float(currentTime-lastTime)/1000.0;
        
        
        let dist = sqrt(nx*nx+ny*ny);
        let new_speed = dist/dt;
        
        self.xspeed = nx/dt;
        self.yspeed = ny/dt;
        self.maccel = (new_speed-mspeed)/dt;
        self.mspeed = new_speed;
        lastTime = currentTime;
        if ((center.getX()<0) || (center.getY()<0)) {
            deactivate();
        }
    }
    //
    func  rotate(theta:Double) {
        
        self.orientation += Float(theta);
        
        //    AffineTransform  trans = AffineTransform.getRotateInstance(theta,center.getX(),center.getY());
        //    geom = trans.createTransformedShape(geom);
        //
        //    // time difference in seconds
        let  currentTime = TuioTime.getSystemTimeMillis();
        let dt = Float(currentTime-lastTime)/1000.0;
        
        // normalized rotation
        let da = Float(theta)/doublePi;
        let new_speed  = Float(da/dt);
        self.raccel = (new_speed-self.rspeed)/dt;
        self.rspeed = new_speed;
        lastTime = currentTime;
    }
    
    func getPosition() -> Point2D {
        return Point2D(x: center.x, y: center.y)
    }
    
    //    func getPointer() -> Point2D {
    //
    //        let x = (int)Math.round(center.getX()-Math.cos(orientation-halfPi)*type.size/3.0);
    //        let y = (int);Math.round(center.getY()-Math.sin(orientation-halfPi)*type.size/3.0);
    //        return Point2D(x,y);
    //    }
    //
    func getAngle() ->Float{
        
        var angle =  orientation.truncatingRemainder(dividingBy: doublePi);
        if (angle<0) {
            angle += doublePi;
            
        }
        return angle;
    }
    //
    //    func  containsPoint( x:Int,  y:Int) ->Bool {
    //        return geom.intersects(x,y,1,1);
    //    }
    
    //    func containsArea( testArea:Area) -> Bool {
    //
    //    Area localArea = new Area(geom);
    //    testArea.intersect(localArea);
    //
    //    return!(testArea.isEmpty());
    //    }
    
    func activate(s_id:Int) {
        
        active = true;
        self.session_id = s_id;
        
        self.lastTime = TuioTime.getSystemTimeMillis(); //Nano not Milli
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0;
        self.rspeed = 0.0;
        self.maccel = 0.0;
        self.raccel = 0.0;
    }
    
    func stop() {
        self.lastTime = TuioTime.getSystemTimeMillis(); //Nano not Milli
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0;
        self.rspeed = 0.0;
        self.maccel = 0.0;
        self.raccel = 0.0;
    }
    
    func deactivate() {
        
        active = false;
        
        self.lastTime = TuioTime.getSystemTimeMillis(); //Nano not Milli
        self.xspeed = 0.0;
        self.yspeed = 0.0;
        self.mspeed = 0.0;
        self.rspeed = 0.0;
        self.maccel = 0.0;
        self.raccel = 0.0;
    }
    
    func  isActive() -> Bool {
        
        return active;
    }
    
    
    
}
