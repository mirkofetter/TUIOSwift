//
//  TuioObject.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//


import Foundation


/**
 * The TuioObject class encapsulates /tuio/2Dobj TUIO objects.
 *
 * @author Martin Kaltenbrunner
 * @version 1.1.6
 
 */
class TuioObject: TuioContainer{
    
    
    /**
     * The individual symbol ID number that is assigned to each TuioObject.
     */
    
    private var symbol_id:Int;
    
    /**
     * The rotation angle value.
     */
    private var angle:Float;
    
    /**
     * The rotation speed value.
     */
    
     var rotation_speed:Float;
    
    /**
     * The rotation acceleration value.
     */
    
     var rotation_accel:Float;
    
    /**
     * Defines the ROTATING state.
     */
    
    static let TUIO_ROTATING = 5;
    
    /**
     * This constructor takes a TuioTime argument and assigns it along with the provided
     * Session ID, Symbol ID, X and Y coordinate and angle to the newly created TuioObject.
     *
     * @param	ttime	the TuioTime to assign
     * @param	si	the Session ID  to assign
     * @param	sym	the Symbol ID  to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	a	the angle to assign
     */
    
    init(ttime:TuioTime,  si:CLong,  sym:Int,  xp:Float,  yp:Float, a:Float) {
        self.symbol_id = sym;
        angle = a;
        rotation_speed = 0.0;
        rotation_accel = 0.0;
        super.init(ttime: ttime, si: si,xp: xp,yp: yp)
        
    }
    
    /**
     * This constructor takes the provided Session ID, Symbol ID, X and Y coordinate
     * and angle, and assigs these values to the newly created TuioObject.
     *
     * @param	si	the Session ID  to assign
     * @param	sym	the Symbol ID  to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	a	the angle to assign
     */
    
    init( si:CLong,  sym:Int,  xp:Float,  yp:Float, a:Float) {
        self.symbol_id = sym;
        angle = a;
        rotation_speed = 0.0;
        rotation_accel = 0.0;
        super.init(si: si,xp: xp,yp: yp)
        
    }
    
    
    /**
     * This constructor takes the atttibutes of the provided TuioObject
     * and assigs these values to the newly created TuioObject.
     *
     * @param	tobj	the TuioObject to assign
     */
    
    init ( tobj:TuioObject) {
        self.symbol_id = tobj.getSymbolID();
        angle = tobj.angle;
        rotation_speed = tobj.rotation_speed;
        rotation_accel = tobj.rotation_accel;
        super.init(tcon: tobj);
        
    }
    
    /**
     * Takes a TuioTime argument and assigns it along with the provided
     * X and Y coordinate, angle, X and Y velocity, motion acceleration,
     * rotation speed and rotation acceleration to the private TuioObject attributes.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	a	the angle coordinate to assign
     * @param	xs	the X velocity to assign
     * @param	ys	the Y velocity to assign
     * @param	rs	the rotation velocity to assign
     * @param	ma	the motion acceleration to assign
     * @param	ra	the rotation acceleration to assign
     */
    
    func update(ttime:TuioTime,  xp:Float,  yp:Float, a:Float,xs:Float,  ys:Float,rs:Float,  ma:Float, ra:Float) {
        
        super.update(ttime:ttime, xp: xp,yp: yp,xs: xs,ys: ys,ma: ma);
        
        angle = a;
        rotation_speed = rs;
        rotation_accel = ra;
        if ((!(rotation_accel==0)) && (!(state==TuioContainer.TUIO_STOPPED))) {
            state = TuioObject.TUIO_ROTATING;
        }
    }
    
    /**
     * Assigns the provided X and Y coordinate, angle, X and Y velocity, motion acceleration
     * rotation velocity and rotation acceleration to the private TuioContainer attributes.
     * The TuioTime time stamp remains unchanged.
     *
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	a	the angle coordinate to assign
     * @param	xs	the X velocity to assign
     * @param	ys	the Y velocity to assign
     * @param	rs	the rotation velocity to assign
     * @param	ma	the motion acceleration to assign
     * @param	ra	the rotation acceleration to assign
     */
    
    func update(  xp:Float,  yp:Float, a:Float,xs:Float,  ys:Float,rs:Float,  ma:Float, ra:Float) {
        
        super.update(xp: xp,yp: yp,xs: xs,ys: ys,ma: ma);
        angle = a;
        rotation_speed = rs;
        rotation_accel = ra;
        if ((!(rotation_accel==0)) && (!(state==TuioContainer.TUIO_STOPPED))) {
            state = TuioObject.TUIO_ROTATING;
        }
    }
    
    
    /**
     * Takes a TuioTime argument and assigns it along with the provided
     * X and Y coordinate and angle to the private TuioObject attributes.
     * The speed and accleration values are calculated accordingly.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	a	the angle coordinate to assign
     */
    
    func update(ttime:TuioTime,  xp:Float,  yp:Float, a:Float){
        
        let lastPoint:TuioPoint = path.getLast()!;
        super.update(ttime:ttime, xp: xp,yp: yp);
        
        
        let diffTime:TuioTime = currentTime.subtract(ttime: lastPoint.getTuioTime());

        let dt:Float = Float(diffTime.getTotalMilliseconds())/1000.0 //ToDo Check conversion
        let last_angle = self.angle;
        let last_rotation_speed = rotation_speed;
        let angle = a;
        
        var da = (angle-last_angle)/(2.0*Float.pi);
        if (da>0.75){
            da-=1.0;
        }
        else {
            if (da < -0.75) {
                da+=1.0;
            }
        }
        
        rotation_speed = da/dt;
        rotation_accel = (rotation_speed - last_rotation_speed)/dt;
        if ((!(rotation_accel==0)) && (!(state==TuioContainer.TUIO_STOPPED))) {
            state = TuioObject.TUIO_ROTATING;
        }    }
    
    /**
     * Takes the atttibutes of the provided TuioObject
     * and assigs these values to this TuioObject.
     * The TuioTime time stamp of this TuioContainer remains unchanged.
     *
     * @param	tobj	the TuioContainer to assign
     */
     func update ( tobj:TuioObject) {
        super.update(tcon: tobj);
        angle = tobj.getAngle();
        rotation_speed = tobj.getRotationSpeed();
        rotation_accel = tobj.getRotationAccel();
        if ((rotation_accel==0) && (!(state==TuioContainer.TUIO_STOPPED))) {
            state = TuioObject.TUIO_ROTATING;
        }
    }
    
    /**
     * This method is used to calculate the speed and acceleration values of a
     * TuioObject with unchanged position and angle.
     *
     * @param	ttime	the TuioTime to assign
     */
    override func stop ( ttime:TuioTime) {
        update(ttime: ttime,xp: xpos,yp: ypos, a: angle);
    }
    
    /**
     * Returns the symbol ID of this TuioObject.
     * @return	the symbol ID of this TuioObject
     */
    func getSymbolID() -> Int {
        return symbol_id;
    }
    
    /**
     * Returns the rotation angle of this TuioObject.
     * @return	the rotation angle of this TuioObject
     */
    func  getAngle() -> Float{
        return angle;
    }
    
    /**
     * Returns the rotation angle in degrees of this TuioObject.
     * @return	the rotation angle in degrees of this TuioObject
     */
    func  getAngleDegrees() -> Float{
        return angle/Float.pi*180.0;
    }
    
    /**
     * Returns the rotation speed of this TuioObject.
     * @return	the rotation speed of this TuioObject
     */
    func  getRotationSpeed() -> Float{
        return rotation_speed;
    }
    
    /**
     * Returns the rotation acceleration of this TuioObject.
     * @return	the rotation acceleration of this TuioObject
     */
    func  getRotationAccel() -> Float  {
        return rotation_accel;
    }
    
    /**
     * Returns true of this TuioObject is moving.
     * @return	true of this TuioObject is moving
     */
    override func  isMoving() -> Bool {
        if ((state==TuioContainer.TUIO_ACCELERATING) || (state==TuioContainer.TUIO_DECELERATING) || (state==TuioObject.TUIO_ROTATING))
        {
            return true;
        }
        else {
            return false;
            
        }
    }
    
    
    
}




