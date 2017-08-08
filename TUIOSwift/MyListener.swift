//
//  MyListener.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 18.04.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


class MyListener: TuioListener {

    var name = "Listener"
    
    init() {
    }
    
    init(name:String) {
        self.name=name;
    }
    
    
    
    func addTuioObject( tobj:TuioObject){
        
    }
    
    /**
     * This callback method is invoked by the TuioClient when an existing TuioObject is updated during the session.
     *
     * @param  tobj  the TuioObject reference associated to the updateTuioObject event
     */
    func updateTuioObject(tobj:TuioObject){}
    
    
    /**
     * This callback method is invoked by the TuioClient when an existing TuioObject is removed from the session.
     *
     * @param  tobj  the TuioObject reference associated to the removeTuioObject event
     */
    func removeTuioObject(tobj:TuioObject){}
    
    /**
     * This callback method is invoked by the TuioClient when a new TuioCursor is added to the session.
     *
     * @param  tcur  the TuioCursor reference associated to the addTuioCursor event
     */
    func addTuioCursor(tcur:TuioCursor){
     print("\(name)  detected Cursor")
    }
    
    /**
     * This callback method is invoked by the TuioClient when an existing TuioCursor is updated during the session.
     *
     * @param  tcur  the TuioCursor reference associated to the updateTuioCursor event
     */
    func updateTuioCursor(tcur:TuioCursor){}
    /**
     * This callback method is invoked by the TuioClient when an existing TuioCursor is removed from the session.
     *
     * @param  tcur  the TuioCursor reference associated to the removeTuioCursor event
     */
    func removeTuioCursor(tcur:TuioCursor){}
    
    /**
     * This callback method is invoked by the TuioClient when a new TuioBlob is added to the session.
     *
     * @param  tblb  the TuioBlob reference associated to the addTuioBlob event
     */
    func addTuioBlob( tblb:TuioBlob){}
    
    /**
     * This callback method is invoked by the TuioClient when an existing TuioBlob is updated during the session.
     *
     * @param  tblb  the TuioBlob reference associated to the updateTuioBlob event
     */
    func updateTuioBlob(tblb:TuioBlob){}
    
    /**
     * This callback method is invoked by the TuioClient when an existing TuioBlob is removed from the session.
     *
     * @param  tblb  the TuioBlob reference associated to the removeTuioBlob event
     */
    func removeTuioBlob(tblb:TuioBlob){}
    /**
     * This callback method is invoked by the TuioClient to mark the end of a received TUIO message bundle.
     *
     * @param  ftime  the TuioTime associated to the current TUIO message bundle
     */
    func refresh( ftime:TuioTime){}

    
    
}

