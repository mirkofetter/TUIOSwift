//
//  TuioPoint.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


/**
 * The TuioPoint class on the one hand is a simple container and utility class to handle TUIO positions in general,
 * on the other hand the TuioPoint is the base class for the TuioCursor and TuioObject classes.
 *
 * @author Mirko Fetter
 * @version 0.9
 *
 * 1:1 Swift port of the TUIO 1.1 Java Library by Martin Kaltenbrunner
 */

class TuioPoint {
    
    
    /**
     * X coordinate, representated as a floating point value in a range of 0..1
     */
      var xpos:Float;
    /**
     * Y coordinate, representated as a floating point value in a range of 0..1
     */
     var ypos:Float;
    /**
     * The time stamp of the last update represented as TuioTime (time since session start)
     */
     var currentTime:TuioTime;
    //protected TuioTime currentTime;
    /**
     * The creation time of this TuioPoint represented as TuioTime (time since session start)
     */
    
     var startTime:TuioTime;
    
    /**
     * The default constructor takes no arguments and sets
     * its coordinate attributes to zero and its time stamp to the current session time.
     */
    
    init() {
        //New Instance initialization goes here
        self.xpos = 0.0;
        self.ypos = 0.0;
        self.currentTime = TuioTime.getSessionTime() // TuioTime.getSessionTime();
        self.startTime = TuioTime(ttime: currentTime) //new TuioTime(currentTime);
    }
    
    
    /**
     * This constructor takes two floating point coordinate arguments and sets
     * its coordinate attributes to these values and its time stamp to the current session time.
     *
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    init( xp:Float,  yp:Float) {
        self.xpos = xp;
        self.ypos = yp;
        self.currentTime = TuioTime.getSessionTime();
        self.startTime =  TuioTime(ttime: currentTime);
    }
    
    
    
    /**
     * This constructor takes a TuioPoint argument and sets its coordinate attributes
     * to the coordinates of the provided TuioPoint and its time stamp to the current session time.
     *
     * @param	tpoint	the TuioPoint to assign
     */
    
    
    init( tpoint:TuioPoint) {
        self.xpos = tpoint.getX();
        self.ypos = tpoint.getY();
        self.currentTime = TuioTime.getSessionTime();
        self.startTime =  TuioTime(ttime: currentTime);
    }
    
    /**
     * This constructor takes a TuioTime object and two floating point coordinate arguments and sets
     * its coordinate attributes to these values and its time stamp to the provided TUIO time object.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    init( ttime: TuioTime,  xp:Float,  yp:Float) {
        self.xpos = xp;
        self.ypos = yp;
        self.currentTime =  TuioTime(ttime: ttime);
        self.startTime =  TuioTime(ttime: currentTime);
    }
    
    
    /**
     * Takes a TuioPoint argument and updates its coordinate attributes
     * to the coordinates of the provided TuioPoint and leaves its time stamp unchanged.
     *
     * @param	tpoint	the TuioPoint to assign
     */
    func update(tpoint:TuioPoint) {
        self.xpos = tpoint.getX();
        self.ypos = tpoint.getY();
    }
    
    /**
     * Takes two floating point coordinate arguments and updates its coordinate attributes
     * to the coordinates of the provided TuioPoint and leaves its time stamp unchanged.
     *
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    func update(xp:Float,  yp:Float) {
        xpos = xp;
        ypos = yp;
    }
    
    /**
     * Takes a TuioTime object and two floating point coordinate arguments and updates its coordinate attributes
     * to the coordinates of the provided TuioPoint and its time stamp to the provided TUIO time object.
     *
     * @param	ttime	the TuioTime to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    func update( ttime: TuioTime,  xp:Float,  yp:Float) {
        xpos = xp;
        ypos = yp;
        currentTime =  TuioTime(ttime: ttime);
    }
    
    /**
     * Returns the X coordinate of this TuioPoint.
     * @return	the X coordinate of this TuioPoint
     */
    
    func getX() -> Float{
        return xpos;
    }
    /**
     * Returns the Y coordinate of this TuioPoint.
     * @return	the Y coordinate of this TuioPoint
     */
    func  getY()-> Float{
        return xpos;
    }
    
    
    
    /**
     * Returns the distance to the provided coordinates
     *
     * @param	xp	the X coordinate of the distant point
     * @param	yp	the Y coordinate of the distant point
     * @return	the distance to the provided coordinates
     */
    func getDistance(xp:Float,  yp:Float) -> Float {
        let dx = xpos-xp;
        let dy = ypos-yp;
        
        return sqrt(dx*dx+dy*dy);
    }
    
    /**
     * Returns the distance to the provided TuioPoint
     *
     * @param	tpoint	the distant TuioPoint
     * @return	the distance to the provided TuioPoint
     */
    func getDistance(tpoint:TuioPoint )->Float {
        return getDistance(xp: tpoint.getX(),yp: tpoint.getY());
    }
    
    
    
    
    /**
     * Returns the angle to the provided coordinates
     *
     * @param	xp	the X coordinate of the distant point
     * @param	yp	the Y coordinate of the distant point
     * @return	the angle to the provided coordinates
     */
    func getAngle(xp:Float,  yp:Float) -> Float {
        
        let side = xpos-xp;
        let height = ypos-yp;
        let distance = getDistance(xp: xp,yp: yp);
        
        var angle = (Float)(asin(side/distance)+Float.pi/2);
        if (height<0) {
            angle = 2.0*Float.pi-angle;
        }
        
        return angle;
    }
    
    /**
     * Returns the angle to the provided TuioPoint
     *
     * @param	tpoint	the distant TuioPoint
     * @return	the angle to the provided TuioPoint
     */
    func getAngle(tpoint:TuioPoint )->Float {
        return getAngle(xp: tpoint.getX(),yp: tpoint.getY());
    }
    
    /**
     * Returns the angle in degrees to the provided coordinates
     *
     * @param	xp	the X coordinate of the distant point
     * @param	yp	the Y coordinate of the distant point
     * @return	the angle in degrees to the provided TuioPoint
     */
    func getAngleDegrees(xp:Float,  yp:Float) -> Float {
        return (getAngle(xp:xp,yp: yp)/Float.pi)*180.0;
    }
    
    /**
     * Returns the angle in degrees to the provided TuioPoint
     *
     * @param	tpoint	the distant TuioPoint
     * @return	the angle in degrees to the provided TuioPoint
     */
    func getAngleDegrees(tpoint:TuioPoint )->Float  {
        return (getAngle(tpoint:tpoint)/Float.pi)*180.0;
    }
    
    
    /**
     * Returns the X coordinate in pixels relative to the provided screen width.
     *
     * @param	width	the screen width
     * @return	the X coordinate of this TuioPoint in pixels relative to the provided screen width
     */
    func getScreenX(width: Int) -> Int {
        return Int(round((xpos * Float(width))))
    }
    
    /**
     * Returns the Y coordinate in pixels relative to the provided screen height.
     *
     * @param	height	the screen height
     * @return	the Y coordinate of this TuioPoint in pixels relative to the provided screen height
     */
    
    func getScreenY(height: Int) -> Int {
        return Int(round((xpos * Float(height))))
        
    }
    
    /**
     * Returns the time stamp of this TuioPoint as TuioTime.
     *
     * @return	the time stamp of this TuioPoint as TuioTime
     */
    func getTuioTime() -> TuioTime{
        return  TuioTime(ttime: currentTime);
    }
    
    /**
     * Returns the start time of this TuioPoint as TuioTime.
     *
     * @return	the start time of this TuioPoint as TuioTime
     */
    func getStartTime() -> TuioTime{
        return  TuioTime(ttime: startTime);
    }
}
