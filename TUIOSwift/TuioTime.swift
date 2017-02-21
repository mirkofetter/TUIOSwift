//
//  TuioTime.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation

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
    internal static var   start_seconds:CLong = 0;
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
    
    init ( sec:CLong, usec:CLong) {
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
    
    static func getSessionTime()->TuioTime{
        return TuioTime()
    }
}
