//
//  TuioContainer.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


/**
 * The abstract TuioContainer class defines common attributes that apply to both subclasses {@link TuioObject} and {@link TuioCursor}.
 *
 * @author Mirko Fetter
 * @version 0.9
 *
 * 1:1 Swift port of the TUIO 1.1 Java Library by Martin Kaltenbrunner
 */

class TuioContainer:TuioPoint {
    
    
    
    /**
     * The unique session ID number that is assigned to each TUIO object or cursor.
     */
    var session_id:CLong
    
    /**
     * The X-axis velocity value.
     */
    var x_speed:Float
    
    /**
     * The Y-axis velocity value.
     */
    var y_speed:Float
    /**
     * The motion speed value.
     */
    var motion_speed:Float
    
    /**
     * The motion acceleration value.
     */
    var motion_accel:Float
    
    /**
     * A Vector of TuioPoints containing all the previous positions of the TUIO component.
     */
    internal var path:Queue<TuioPoint>;
    
    
    /**
     * Reflects the current state of the TuioComponent
     */
    var state:Int
    
    
    /**
     * Defines the maximum path length.
     */
    static var MAX_PATH_LENGTH:Int = 128;
    /**
     * Defines the ADDED state.
     */
    static let  TUIO_ADDED:Int = 0;
    /**
     * Defines the ACCELERATING state.
     */
    static let TUIO_ACCELERATING:Int = 1;
    /**
     * Defines the DECELERATING state.
     */
    static let  TUIO_DECELERATING:Int = 2;
    /**
     * Defines the STOPPED state.
     */
    static let TUIO_STOPPED:Int = 3;
    /**
     * Defines the REMOVED state.
     */
    static let TUIO_REMOVED:Int = 4;
    
    private  override init(){
        self.session_id=0;
        self.x_speed=0
        self.y_speed=0
        self.motion_speed=0
        self.motion_accel=0
        self.state=0
        path = Queue<TuioPoint>()
        
        super.init()
    }
    
    
    /**
     * This constructor takes a TuioTime argument and assigns it along with the provided
     * Session ID, X and Y coordinate to the newly created TuioContainer.
     *
     * @param	ttime	the TuioTime to assign
     * @param	si	the Session ID to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    init(ttime:TuioTime,  si:CLong,  xp:Float,  yp:Float) {
        
        
        session_id = si;
        x_speed = 0.0;
        y_speed = 0.0;
        motion_speed = 0.0;
        motion_accel = 0.0;
        
        path = Queue<TuioPoint>();
        state = TuioContainer.TUIO_ADDED;
        
        super.init(ttime: ttime,xp: xp,yp: yp);
        
        path.enqueue(e: TuioPoint(ttime: currentTime,  xp:xpos,  yp:ypos));
    }
    
    /**
     * This constructor takes the provided Session ID, X and Y coordinate
     * and assigs these values to the newly created TuioContainer.
     *
     * @param	si	the Session ID to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    init(  si:CLong,  xp:Float,  yp:Float) {
        session_id = si;
        x_speed = 0.0;
        y_speed = 0.0;
        motion_speed = 0.0;
        motion_accel = 0.0;
        
        path =  Queue<TuioPoint>();
        state = TuioContainer.TUIO_ADDED;
        
        super.init(xp: xp,yp: yp);
        
        path.enqueue(e: TuioPoint(ttime: currentTime,  xp:xpos,  yp:ypos));
        
        
    }
    
    /**
     * This constructor takes the atttibutes of the provided TuioContainer
     * and assigs these values to the newly created TuioContainer.
     *
     * @param	tcon	the TuioContainer to assign
     */
    init( tcon:TuioContainer) {
        //        super.init(tpoint:TuioContainer);
        
        
        
        session_id = tcon.getSessionID();
        
        x_speed = tcon.getXSpeed()
        y_speed = tcon.getYSpeed()
        motion_speed = 0.0;
        motion_accel = 0.0;
        
        
        
        path =  Queue<TuioPoint>();
        state = TuioContainer.TUIO_ADDED;
        
        super.init(ttime: tcon.getTuioTime(),xp: tcon.getX(),yp: tcon.getY());
        
        path.enqueue(e: TuioPoint(ttime: currentTime,  xp:xpos,  yp:ypos));
        
        
    }
    
    /**
     * Takes a TuioTime argument and assigns it along with the provided
     * X and Y coordinate to the private TuioContainer attributes.
     * The speed and accleration values are calculated accordingly.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    override func update(ttime:TuioTime,  xp:Float, yp:Float) {
        let lastPoint:TuioPoint = path.getLast()!;
        super.update(ttime: ttime,xp: xp,yp: yp);
        
        let diffTime:TuioTime = currentTime.subtract(ttime: lastPoint.getTuioTime());
        
        let dt:Float = Float(diffTime.getTotalMilliseconds())/1000.0 //ToDo Check conversion
        let dx:Float = self.xpos - lastPoint.getX();
        let dy = self.ypos - lastPoint.getY();
        let dist = Float(sqrt(dx*dx+dy*dy));
        let last_motion_speed = self.motion_speed;
        
        self.x_speed = dx/dt;
        self.y_speed = dy/dt;
        self.motion_speed = dist/dt;
        self.motion_accel = (motion_speed - last_motion_speed)/dt;
        
        path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
        if (path.size>TuioContainer.MAX_PATH_LENGTH) {
            path.removeFirst();
        }
        
        if (motion_accel>0) {
            
            state = TuioContainer.TUIO_ACCELERATING;}
            
        else if (motion_accel<0) {
            
            state = TuioContainer.TUIO_DECELERATING;}
            
        else {
            
            state = TuioContainer.TUIO_STOPPED;}
    }
    
    /**
     * This method is used to calculate the speed and acceleration values of
     * TuioContainers with unchanged positions.
     *
     * @param	ttime	the TuioTime to assign
     */
    func stop( ttime:TuioTime) {
        update(ttime: ttime,xp: xpos,yp: ypos);
    }
    
    
    /**
     * Takes a TuioTime argument and assigns it along with the provided
     * X and Y coordinate, X and Y velocity and acceleration
     * to the private TuioContainer attributes.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	xs	the X velocity to assign
     * @param	ys	the Y velocity to assign
     * @param	ma	the acceleration to assign
     */
    
    
    func update(ttime:TuioTime,  xp:Float, yp:Float, xs:Float,  ys:Float, ma:Float) {
        super.update(ttime: ttime,xp: xp,yp: yp);
        
        self.x_speed = xs;
        self.y_speed = ys;
        
        self.motion_speed = Float(sqrt(x_speed*x_speed+y_speed*y_speed));
        self.motion_accel = ma;
        
        path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
        
        path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
        if (path.size>TuioContainer.MAX_PATH_LENGTH) {
            path.removeFirst();
        }
        
        if (motion_accel>0) {
            
            state = TuioContainer.TUIO_ACCELERATING;}
            
        else if (motion_accel<0) {
            
            state = TuioContainer.TUIO_DECELERATING;}
            
        else {
            
            state = TuioContainer.TUIO_STOPPED;
        }
        
    }
    
    /**
     * Assigns the provided X and Y coordinate, X and Y velocity and acceleration
     * to the private TuioContainer attributes. The TuioTime time stamp remains unchanged.
     *
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     * @param	xs	the X velocity to assign
     * @param	ys	the Y velocity to assign
     * @param	ma	the acceleration to assign
     */
    func update( xp:Float, yp:Float, xs:Float,  ys:Float, ma:Float) {
        super.update(xp: xp,yp: yp);
        
        self.x_speed = xs;
        self.y_speed = ys;
        
        self.motion_speed = Float(sqrt(x_speed*x_speed+y_speed*y_speed));
        self.motion_accel = ma;
        
        
        path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
        
        path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
        if (path.size>TuioContainer.MAX_PATH_LENGTH) {
            path.removeFirst();
        }
        
        if (motion_accel>0) {
            
            state = TuioContainer.TUIO_ACCELERATING;}
            
        else if (motion_accel<0) {
            
            state = TuioContainer.TUIO_DECELERATING;}
            
        else {
            
            state = TuioContainer.TUIO_STOPPED;
        }
    }
    
    /**
     * Takes the atttibutes of the provided TuioContainer
     * and assigs these values to this TuioContainer.
     * The TuioTime time stamp of this TuioContainer remains unchanged.
     *
     * @param	tcon	the TuioContainer to assign
     */
    func update ( tcon:TuioContainer) {
    super.update(tpoint: tcon);
    self.x_speed = tcon.getXSpeed();
    self.y_speed = tcon.getYSpeed();
    self.motion_speed = tcon.getMotionSpeed();
    self.motion_accel = tcon.getMotionAccel();
    
    path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
    
    path.addLast(e: TuioPoint(ttime: currentTime,xp: xpos,yp: ypos));
    if (path.size>TuioContainer.MAX_PATH_LENGTH) {
    path.removeFirst();
    }
    
    if (motion_accel>0) {
    
    state = TuioContainer.TUIO_ACCELERATING;}
    
    else if (motion_accel<0) {
    
    state = TuioContainer.TUIO_DECELERATING;}
    
    else {
    
    state = TuioContainer.TUIO_STOPPED;
    }
    }
    
    
    /**
     * Assigns the REMOVE state to this TuioContainer and sets
     * its TuioTime time stamp to the provided TuioTime argument.
     *
     * @param	ttime	the TuioTime to assign
     */
    func remove(ttime:TuioTime) {
        currentTime =  TuioTime(ttime:ttime);
        state = TuioContainer.TUIO_REMOVED;
    }
    
    /**
     * Returns the Session ID of this TuioContainer.
     * @return	the Session ID of this TuioContainer
     */
    func getSessionID() ->CLong{
        return session_id;
    }
    
    /**
     * Returns the X velocity of this TuioContainer.
     * @return	the X velocity of this TuioContainer
     */
    func getXSpeed() ->Float{
        return x_speed;
    }
    
    /**
     * Returns the Y velocity of this TuioContainer.
     * @return	the Y velocity of this TuioContainer
     */
    func getYSpeed() ->Float{
        return y_speed;
    }
    
    
    /**
     * Returns the position of this TuioContainer.
     * @return	the position of this TuioContainer
     */
    func getPosition() -> TuioPoint{
        return  TuioPoint(xp: xpos,yp: ypos);
    }
    
    
    
    /**
     * Returns the path of this TuioContainer.
     * @return	the path of this TuioContainer
     */
    func  getPath() -> Queue<TuioPoint>{
        return path;
    }
    
    /**
     * Sets the maximum path length
     * param	the maximum path length
     */
    static func setMaxPathLength(length:Int) {
        MAX_PATH_LENGTH = length;
    }
    
    /**
     * Returns the motion speed of this TuioContainer.
     * @return	the motion speed of this TuioContainer
     */
    func getMotionSpeed()-> Float {
        return motion_speed;
    }
    
    /**
     * Returns the motion acceleration of this TuioContainer.
     * @return	the motion acceleration of this TuioContainer
     */
    func getMotionAccel() -> Float {
        return motion_accel;
    }
    
    /**
     * Returns the TUIO state of this TuioContainer.
     * @return	the TUIO state of this TuioContainer
     */
    func getTuioState() -> Int{
        return state;
    }
    
    /**
     * Returns true of this TuioContainer is moving.
     * @return	true of this TuioContainer is moving
     */
    func  isMoving()-> Bool {
        
        if ((state==TuioContainer.TUIO_ACCELERATING) || (state==TuioContainer.TUIO_DECELERATING)){
            return true
        }
        else {
            return false
        }
    }
    
    
}
