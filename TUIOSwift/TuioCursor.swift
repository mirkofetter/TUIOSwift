//
//  TuioCursor.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


/**
 * The TuioCursor class encapsulates /tuio/2Dcur TUIO cursors.
 *
 * @author Martin Kaltenbrunner
 * @version 1.1.6
 */

 class TuioCursor: TuioContainer {
    
    /**
     * The individual cursor ID number that is assigned to each TuioCursor.
     */
    private var cursor_id:Int;
    
    /**
     * This constructor takes a TuioTime argument and assigns it along  with the provided
     * Session ID, Cursor ID, X and Y coordinate to the newly created TuioCursor.
     *
     * @param	ttime	the TuioTime to assign
     * @param	si	the Session ID  to assign
     * @param	ci	the Cursor ID  to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    
    init(ttime:TuioTime,  si:CLong,  ci:Int,  xp:Float,  yp:Float) {
        self.cursor_id = ci;
        super.init(ttime: ttime, si: si,xp: xp,yp: yp)

  
    }
    
    /**
     * This constructor takes the provided Session ID, Cursor ID, X and Y coordinate
     * and assigs these values to the newly created TuioCursor.
     *
     * @param	si	the Session ID  to assign
     * @param	ci	the Cursor ID  to assign
     * @param	xp	the X coordinate to assign
     * @param	yp	the Y coordinate to assign
     */
    
    init( si:CLong,  ci:Int,  xp:Float,  yp:Float) {
        self.cursor_id = ci;
        super.init( si: si,xp: xp,yp: yp)

    }
    
  
    
    /**
     * This constructor takes the atttibutes of the provided TuioCursor
     * and assigs these values to the newly created TuioCursor.
     *
     * @param	tcur	the TuioCursor to assign
     */
    init ( tcur:TuioCursor) {
    self.cursor_id = tcur.getCursorID();
    super.init(tcon: tcur);
    }
    
    /**
     * Returns the Cursor ID of this TuioCursor.
     * @return	the Cursor ID of this TuioCursor
     */
    func  getCursorID() -> Int {
    return cursor_id;
    }
    
}
