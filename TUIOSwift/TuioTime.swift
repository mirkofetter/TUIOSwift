//
//  TuioTime.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


/**
 * The TuioTime class is a simple structure that is used to reprent the time that has elapsed since the session start.
 * The time is internally represented as seconds and fractions of microseconds which should be more than sufficient for gesture related timing requirements.
 * Therefore at the beginning of a typical TUIO session the static method initSession() will set the reference time for the session.
 * Another important static method getSessionTime will return a TuioTime object representing the time elapsed since the session start.
 * The class also provides various addtional convience method, which allow some simple time arithmetics.
 *
 * @author Mirko Fetter
 * @version 0.9
 *
 * 1:1 Swift port of the TUIO 1.1 Java Library by Martin Kaltenbrunner
 */

class TuioTime {
    
    
    /**
     * the time since session start in seconds
     */
    internal var seconds:CLong = 0;
    /**
     * time fraction in microseconds
     */
    internal var  micro_seconds:CLong = 0;
    /**
     * the session start time in seconds
     */
    internal static var  start_seconds:CLong = 0;
    /**
     * start time fraction in microseconds
     */
    internal static var  start_micro_seconds:CLong = 0;
    /**
     * the associated frame ID
     */
    internal var frame_id:CLong = 0;
    
    /**
     * The default constructor takes no arguments and sets
     * the Seconds and Microseconds attributes of the newly created TuioTime both to zero.
     */
    init() {
        self.seconds = 0;
        self.micro_seconds = 0;
    }
    
    
    /**
     * This constructor takes the provided time represented in total Milliseconds
     * and assigs this value to the newly created TuioTime.
     *
     * @param  msec  the total time in Millseconds
     */
    init ( msec:CLong) {
        self.seconds = msec/1000;
        self.micro_seconds = 1000*(msec%1000);
    }
    
    /**
     * This constructor takes the provided time represented in Seconds and Microseconds
     * and assigs these value to the newly created TuioTime.
     *
     * @param  sec  the total time in seconds
     * @param  usec	the microseconds time component
     */
    
    init (sec:CLong, usec:CLong) {
        self.seconds = sec;
        self.micro_seconds = usec;
    }
    
    /**
     * This constructor takes the provided TuioTime
     * and assigs its Seconds and Microseconds values to the newly created TuioTime.
     *
     * @param  ttime  the TuioTime used to copy
     */
    init(ttime:TuioTime) {
        self.seconds = ttime.getSeconds();
        self.micro_seconds = ttime.getMicroseconds();
    }
    
    /**
     * This constructor takes the provided TuioTime
     * and assigs its Seconds and Microseconds values to the newly created TuioTime.
     *
     * @param  ttime  the TuioTime used to copy
     * @param  the Frame ID to associate
     */
    init(ttime:TuioTime, f_id:CLong) {
        self.seconds = ttime.getSeconds();
        self.micro_seconds = ttime.getMicroseconds();
        self.frame_id = f_id;
    }
    
    
    
    /**
     * Sums the provided time value represented in total Microseconds to this TuioTime.
     *
     * @param  us	the total time to add in Microseconds
     * @return the sum of this TuioTime with the provided argument in microseconds
     */
    func add(us:CLong) -> TuioTime{
        let sec:CLong = seconds + us/1000000;
        let usec:CLong = micro_seconds + us%1000000;
        return  TuioTime(sec: sec,usec: usec);
    }
    
    
    /**
     * Sums the provided TuioTime to the private Seconds and Microseconds attributes.
     *
     * @param  ttime	the TuioTime to add
     * @return the sum of this TuioTime with the provided TuioTime argument
     */
    func add( ttime: TuioTime) -> TuioTime{
        var sec:CLong = seconds + ttime.getSeconds();
        var usec:CLong = micro_seconds + ttime.getMicroseconds();
        sec += usec/1000000;
        usec = usec%1000000;
        return  TuioTime(sec:sec,usec:usec);
    }
    
    
    
    
    
    
    /**
     * Subtracts the provided time represented in Microseconds from the private Seconds and Microseconds attributes.
     *
     * @param  us	the total time to subtract in Microseconds
     * @return the subtraction result of this TuioTime minus the provided time in Microseconds
     */
    func subtract(us:CLong) -> TuioTime{
        var sec:CLong = seconds - us/1000000;
        var usec:CLong = micro_seconds - us%1000000;
        
        if (usec<0) {
            usec += 1000000;
            sec-=1;
        }
        
        return  TuioTime(sec:sec,usec:usec);
    }
    
    /**
     * Subtracts the provided TuioTime from the private Seconds and Microseconds attributes.
     *
     * @param  ttime	the TuioTime to subtract
     * @return the subtraction result of this TuioTime minus the provided TuioTime
     */
    func subtract( ttime: TuioTime) -> TuioTime{
        var sec:CLong = seconds - ttime.getSeconds();
        var usec:CLong = micro_seconds - ttime.getMicroseconds();
        
        if (usec<0) {
            usec += 1000000;
            sec-=1;
        }
        
        return  TuioTime(sec:sec,usec:usec);
    }
    
    
    /**
     * Takes a TuioTime argument and compares the provided TuioTime to the private Seconds and Microseconds attributes.
     *
     * @param  ttime	the TuioTime to compare
     * @return true if the two TuioTime have equal Seconds and Microseconds attributes
     */
    func equals( ttime: TuioTime) -> Bool{
        if ((seconds==ttime.getSeconds()) && (micro_seconds==ttime.getMicroseconds())) {
            return true;
        }else {
            return false;
            
        }
    }
    
    /**
     * Resets the seconds and micro_seconds attributes to zero.
     */
    func reset() {
        seconds = 0;
        micro_seconds = 0;
    }
    
    /**
     * Returns the TuioTime Seconds component.
     * @return the TuioTime Seconds component
     */
    func getSeconds()->CLong {
        return seconds;
    }
    
    /**
     * Returns the TuioTime Microseconds component.
     * @return the TuioTime Microseconds component
     */
    func getMicroseconds() ->CLong {
        return micro_seconds;
    }
    
    
    
    /**
     * Returns the total TuioTime in Milliseconds.
     * @return the total TuioTime in Milliseconds
     */
    func getTotalMilliseconds()-> CLong{
        return seconds*1000+micro_seconds/1000;
    }
    
    /**
     * This static method globally resets the TUIO session time.
     */
    static func initSession() {
        let startTime:TuioTime = getSystemTime();
        start_seconds = startTime.getSeconds();
        start_micro_seconds = startTime.getMicroseconds();
    }
    
    /**
     * Returns the present TuioTime representing the time since session start.
     * @return the present TuioTime representing the time since session start
     */
    
    static func getSessionTime()->TuioTime{
        let sessionTime:TuioTime = getSystemTime().subtract(ttime: getStartTime());
        return sessionTime;
    }
    
    
    
    
    /**
     * Returns the absolut TuioTime representing the session start.
     * @return the absolut TuioTime representing the session start
     */
    static func getStartTime()->TuioTime{
        return TuioTime(sec: self.start_seconds, usec: self.start_micro_seconds)
    }
    
    /**
     * Returns the absolut TuioTime representing the current system time.
     * @return the absolut TuioTime representing the current system time
     */
    static func getSystemTime()->TuioTime{
        //ToDo check if this equals Java 	long usec = System.nanoTime()/1000;
        //--
        let time = mach_absolute_time();
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let elapsedNano = (time * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom))/1000;
        let usec:CLong =  CLong(elapsedNano);
        //--
        return  TuioTime(sec: usec/1000000,usec: usec%1000000);
    }
    
    /**
     * associates a Frame ID to this TuioTime.
     * @param  f_id	the Frame ID to associate
     */
    func setFrameID( f_id:CLong) {
        frame_id=f_id;
    }
    
    /**
     * Returns the Frame ID associated to this TuioTime.
     * @return the Frame ID associated to this TuioTime
     */
    func getFrameID() -> CLong {
        return frame_id;
    }
    
    static func getSystemTimeMillis()->CLong{
        //ToDo check if this equals Java 	long usec = System.nanoTime()/1000;
        //--
        let time = mach_absolute_time();
        var timeBaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timeBaseInfo)
        let elapsedNano = (time * UInt64(timeBaseInfo.numer) / UInt64(timeBaseInfo.denom))/1000;
        return  CLong(elapsedNano);
        
        
    }
}
