    //
    //  TuioListener.swift
    //  TUIOSwift
    //
    //  Created by Mirko Fetter on 21.02.17.
    //  Copyright © 2017 grugru. All rights reserved.
    //
    
    import Foundation
    
    
    /**
     * The TuioListener interface provides a simple callback infrastructure which is used by the {@link TuioClient} class
     * to dispatch TUIO events to all registered instances of classes that implement the TuioListener interface defined here.<P>
     * Any class that implements the TuioListener interface is required to implement all of the callback methods defined here.
     * The {@link TuioClient} makes use of these interface methods in order to dispatch TUIO events to all registered TuioListener implementations.<P>
     * <code>
     * class MyTuioListener:TuioListener<br>
     * ...</code><p><code>
     * let listener:MyTuioListener =  MyTuioListener();<br>
     * let client:TuioClient =  TuioClient();<br>
     * client.addTuioListener(listener: listener);<br>
     * client.start();<br>
     * </code>
     *
     * @author Mirko Fetter
     * @version 0.9
     *
     * 1:1 Swift port of the TUIO 1.1 Java Library by Martin Kaltenbrunner
     
     */
    protocol TuioListener {
        
        
        /**
         * This callback method is invoked by the TuioClient when a new TuioObject is added to the session.
         *
         * @param  tobj  the TuioObject reference associated to the addTuioObject event
         */
        func addTuioObject( tobj:TuioObject);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioObject is updated during the session.
         *
         * @param  tobj  the TuioObject reference associated to the updateTuioObject event
         */
        func updateTuioObject(tobj:TuioObject);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioObject is removed from the session.
         *
         * @param  tobj  the TuioObject reference associated to the removeTuioObject event
         */
        func removeTuioObject(tobj:TuioObject);
        
        /**
         * This callback method is invoked by the TuioClient when a new TuioCursor is added to the session.
         *
         * @param  tcur  the TuioCursor reference associated to the addTuioCursor event
         */
        func addTuioCursor(tcur:TuioCursor);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioCursor is updated during the session.
         *
         * @param  tcur  the TuioCursor reference associated to the updateTuioCursor event
         */
        func updateTuioCursor(tcur:TuioCursor);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioCursor is removed from the session.
         *
         * @param  tcur  the TuioCursor reference associated to the removeTuioCursor event
         */
        func removeTuioCursor(tcur:TuioCursor);
        
        /**
         * This callback method is invoked by the TuioClient when a new TuioBlob is added to the session.
         *
         * @param  tblb  the TuioBlob reference associated to the addTuioBlob event
         */
        func addTuioBlob( tblb:TuioBlob);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioBlob is updated during the session.
         *
         * @param  tblb  the TuioBlob reference associated to the updateTuioBlob event
         */
        func updateTuioBlob(tblb:TuioBlob);
        
        /**
         * This callback method is invoked by the TuioClient when an existing TuioBlob is removed from the session.
         *
         * @param  tblb  the TuioBlob reference associated to the removeTuioBlob event
         */
        func removeTuioBlob(tblb:TuioBlob);
        /**
         * This callback method is invoked by the TuioClient to mark the end of a received TUIO message bundle.
         *
         * @param  ftime  the TuioTime associated to the current TUIO message bundle
         */
        func refresh( ftime:TuioTime);
    }
    
