//
//  TUIOClient.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 23.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


/**
 * The TuioClient class is the central TUIO protocol decoder component. It provides a simple callback infrastructure using the {@link TuioListener} interface.
 * In order to receive and decode TUIO messages an instance of TuioClient needs to be created. The TuioClient instance then generates TUIO events
 * which are broadcasted to all registered classes that implement the {@link TuioListener} interface.<P>
 * <code>
 * TuioClient client = new TuioClient();<br>
 * client.addTuioListener(myTuioListener);<br>
 * client.connect();<br>
 * </code>
 *
 * @author Mirko Fetter
 * @version 0.9
 *
 * 1:1 Swift port of the TUIO 1.1 Java Library by Martin Kaltenbrunner
 */


class TUIOClient: F53OSCPacketDestination {
    
    
    
    var  port:Int = 3333;
    //  private OSCPortIn oscPort;
    let oscServer: F53OSCServer;
    private var connected:Bool = false;
    
    private var objectList = [CLong:TuioObject]()
    private var aliveObjectList = [CLong]()
    private var newObjectList = [CLong]()
    
    private var cursorList = [CLong:TuioCursor]()
    private var aliveCursorList = [CLong]()
    private var newCursorList = [CLong]()
    
    private var blobList = [CLong:TuioBlob]()
    private var aliveBlobList = [CLong]()
    private var newBlobList = [CLong]()
    
    
    private var frameObjects = [TuioObject]()
    private var frameCursors = [TuioCursor]()
    private var frameBlobs = [TuioBlob]()
    
    
    private var freeCursorList = [TuioCursor]()
    private var maxCursorID:Int = -1;
    
    private var freeBlobList = [TuioBlob]()
    private var maxBlobID:Int = -1;
    
    private var currentFrame:CLong = 0;
    private var currentTime:TuioTime?;
    
    private var listenerList = [TuioListener]()
    
    
    
    
    
    
    /**
     * The default constructor creates a client that listens to the default TUIO port 3333
     */
    init() {
        oscServer = F53OSCServer.init()
    }
    
    /**
     * This constructor creates a client that listens to the provided port
     *
     * @param  port  the listening port number
     */
    init(port:Int) {
        oscServer = F53OSCServer.init()
        self.port=port;
    }
    /**
     * The TuioClient starts listening to TUIO messages on the configured UDP port
     * All reveived TUIO messages are decoded and the resulting TUIO events are broadcasted to all registered TuioListeners
     */
    func connect() {
        
        TuioTime.initSession();
        currentTime = TuioTime();
        currentTime!.reset();
        
        oscServer.port=UInt16(port)
        oscServer.delegate=self;
        
        if oscServer.startListening() {
            print("Listening for messages on port \(oscServer.port)")
            connected = true;
            
        } else {
            print("TuioClient: failed to connect to port \(oscServer.port)")
            
            connected = false;
            
        }//
        // dispatchMain()
        CFRunLoopRun()
        
    }
    
    /**
     * The TuioClient stops listening to TUIO messages on the configured UDP port
     */
    func disconnect() {
        oscServer.stopListening()
        connected = false;
    }
    
    /**
     * Returns true if this TuioClient is currently connected.
     * @return	true if this TuioClient is currently connected
     */
    func isConnected() -> Bool { return connected; }
    
    /**
     * Adds the provided TuioListener to the list of registered TUIO event listeners
     *
     * @param  listener  the TuioListener to add
     */
    func addTuioListener( listener:TuioListener) {
        listenerList.append(listener)
    }
    
    /**
     * Removes the provided TuioListener from the list of registered TUIO event listeners
     *
     * @param  listener  the TuioListener to remove
     */
    func removeTuioListener(listener:TuioListener) {
        //TODO check if remvoal is correct
        
        let index = listenerList.index(where: { (item) -> Bool in
            item as AnyObject === listener as AnyObject
        })
        listenerList.remove(at: index!)
        
        //        if let index = listenerList.index(of: listener) {
        //            listenerList.remove(at: index)
    }
    
    /**
     * Removes all TuioListener from the list of registered TUIO event listeners
     */
    func removeAllTuioListeners() {
        listenerList.removeAll();
    }
    
    
    /**
     * Returns an ArrayList of all currently active TuioObjects
     *
     * @return  an ArrayList of all currently active TuioObjects
     */
    
    
    func getTuioObjectList() -> [TuioObject]{
        return Array(objectList.values);
    }
    
    
    /**
     * Returns an ArrayList of all currently active TuioCursors
     *
     * @return  an ArrayList of all currently active TuioCursors
     */
    
    
    func getTuioCursorList() -> [TuioCursor]{
        return Array(cursorList.values);
    }
    
    
    
    /**
     * Returns an ArrayList of all currently active TuioBlobs
     *
     * @return  an ArrayList of all currently active TuioBlobs
     */
    
    
    
    func getTuioBlobList() -> [TuioBlob]{
        return Array(blobList.values);
    }
    
    
    
    /**
     * Returns the TuioObject corresponding to the provided Session ID
     * or NULL if the Session ID does not refer to an active TuioObject
     *
     * @param	s_id	the Session ID of the required TuioObject
     * @return  an active TuioObject corresponding to the provided Session ID or NULL
     */
    func  getTuioObject( s_id:CLong) -> TuioObject?{
        return objectList[s_id];
        
    }
    
    
    /**
     * Returns the TuioCursor corresponding to the provided Session ID
     * or NULL if the Session ID does not refer to an active TuioCursor
     *
     * @param	s_id	the Session ID of the required TuioCursor
     * @return  an active TuioCursor corresponding to the provided Session ID or NULL
     */
    
    func  getTuioCursor( s_id:CLong) -> TuioCursor?{
        return cursorList[s_id];
        
    }
    
    /**
     * Returns the TuioBlob corresponding to the provided Session ID
     * or NULL if the Session ID does not refer to an active TuioBlob
     *
     * @param	s_id	the Session ID of the required TuioBlob
     * @return  an active TuioBlob corresponding to the provided Session ID or NULL
     */
    
    func  getTuioBlob( s_id:CLong) -> TuioBlob?{
        return blobList[s_id];
        
    }
    
    
    /**
     * The OSC callback method where all TUIO messages are received and decoded
     * and where the TUIO event callbacks are dispatched
     *
     * @param  message	the received OSC message
     */
    
    public func take(_ message: F53OSCMessage!) {
        
        let args = message.arguments!;
        let command = args[0] as! String;
        let address = message.addressPattern
        
        //-------------------Handle 2Dobj---------------------------
        
        if (address=="/tuio/2Dobj") {
            
            if (command  == "set") {
                
                
                let s_id  = args[1] as! CLong;
                let c_id  = args[2] as! Int;
                let xpos = args[3] as! Float
                let ypos = args[4] as! Float
                let angle = args[5] as! Float
                let xspeed = args[6] as! Float
                let yspeed = args[7] as! Float;
                let rspeed = args[8] as! Float;
                let maccel = args[9] as! Float
                let raccel = args[10] as! Float;
                
                
                print("set obj \(s_id) \(xpos) \(ypos) \(xspeed) \(yspeed) \(maccel)")
                
                if ((objectList[s_id]) != nil){
                    
                    let addObject =  TuioObject(si: s_id, sym: c_id ,xp: xpos,yp: ypos, a:angle);
                    frameObjects.append(addObject);
                    
                    
                } else {
                    let tobj = objectList[s_id]
                    
                    if (tobj==nil){
                        return;
                    }
                    
                    if (!(tobj!.xpos==xpos) || !(tobj!.ypos==ypos) || !(tobj!.x_speed==xspeed) || !(tobj!.y_speed==yspeed) || !(tobj!.rotation_speed==rspeed) || !(tobj!.motion_accel==maccel) || !(tobj!.rotation_accel==raccel)) {
                        
                        
                        let updateObject =  TuioObject(si: s_id,sym: tobj!.getSymbolID(),xp: xpos,yp: ypos, a: angle);
                        updateObject.update(xp: xpos,yp: ypos,xs: xspeed,ys: yspeed,ma: maccel);
                        frameObjects.append(updateObject);
                    }
                    
                }
            } else  if (command  == "alive"){
                
                newObjectList.removeAll();
               
                
                for i in 1 ..< args.count  {
                    // get the message content
                    let s_id:CLong = args[i] as! CLong;
                    
                    newObjectList.append(s_id);
                    // reduce the object list to the lost objects
                    if (aliveObjectList.contains(s_id)){
                        aliveObjectList.delete(element: s_id);
                    }
                }
                //
                //            // remove the remaining objects
                
                for i in 0 ..< aliveObjectList.count{
                    
                    let removeObject:TuioObject =  objectList[aliveObjectList[i]]!;
                    
                    
                    if (!(removeObject==nil)) {
                        removeObject.remove(ttime: currentTime!);
                        frameObjects.append(removeObject)
                    }

                    
                }
                
                
            } else  if (command  == "fseq"){
                
                
                let fseq  = args[1] as! Int;
                var lateFrame = false;
                
                if (fseq>0) {
                    if (fseq>currentFrame) {
                        currentTime = TuioTime.getSessionTime();
                    }
                    if ((fseq>=currentFrame) || ((currentFrame-fseq)>100)){
                        currentFrame = fseq;
                    }  else {
                        lateFrame = true;
                    }
                } else if (TuioTime.getSessionTime().subtract(ttime: currentTime!).getTotalMilliseconds()>100) {
                    currentTime = TuioTime.getSessionTime();
                }
                
                
                
                if (!lateFrame) {
                    //                Enumeration<TuioObject> frameEnum = frameObjects.elements();
                    //                while(frameEnum.hasMoreElements()) {
                    //                    TuioObject tobj = frameEnum.nextElement();
                    //
                    //                    switch (tobj.getTuioState()) {
                    //                    case TuioObject.TUIO_REMOVED:
                    //                        TuioObject removeObject = tobj;
                    //                        removeObject.remove(currentTime);
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.removeTuioObject(removeObject);
                    //                        }
                    //                        objectList.remove(removeObject.getSessionID());
                    //                        break;
                    //
                    //                    case TuioObject.TUIO_ADDED:
                    //                        TuioObject addObject = new TuioObject(currentTime,tobj.getSessionID(),tobj.getSymbolID(),tobj.getX(),tobj.getY(),tobj.getAngle());
                    //                        objectList.put(addObject.getSessionID(),addObject);
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.addTuioObject(addObject);
                    //                        }
                    //                        break;
                    //
                    //                    default:
                    //                        TuioObject updateObject = objectList.get(tobj.getSessionID());
                    //                        if ( (tobj.getX()!=updateObject.getX() && tobj.getXSpeed()==0) || (tobj.getY()!=updateObject.getY() && tobj.getYSpeed()==0) )
                    //                        updateObject.update(currentTime,tobj.getX(),tobj.getY(),tobj.getAngle());
                    //                        else
                    //                        updateObject.update(currentTime,tobj.getX(),tobj.getY(),tobj.getAngle(),tobj.getXSpeed(),tobj.getYSpeed(),tobj.getRotationSpeed(),tobj.getMotionAccel(),tobj.getRotationAccel());
                    //
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.updateTuioObject(updateObject);
                    //                        }
                    //                    }
                    //                }
                    //
                    //                for (int i=0;i<listenerList.size();i++) {
                    //                    TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                    if (listener!=null) listener.refresh(new TuioTime(currentTime,fseq));
                    //                }
                    //
                    //                Vector<Long> buffer = aliveObjectList;
                    //                aliveObjectList = newObjectList;
                    //                // recycling the vector
                    //                newObjectList = buffer;
                }
                frameObjects.removeAll();
            }
            
            //-------------------Handle 2Dcur---------------------------
            
        } else if (address == "/tuio/2Dcur") {
            
            if (command  == "set"){
                
                
                let s_id  = args[1] as! CLong;
                let xpos = args[2] as! Float
                let ypos = args[3] as! Float
                let xspeed = args[4] as! Float
                let yspeed = args[5] as! Float;
                let maccel = args[6] as! Float
                
                print("set cur \(s_id) \(xpos) \(ypos) \(xspeed) \(yspeed) \(maccel)")
                
                if ((cursorList[s_id]) != nil){
                    
                    let addCursor =  TuioCursor(si: s_id, ci: -1 ,xp: xpos,yp: ypos);
                    frameCursors.append(addCursor);
                    
                } else {
                    let tcur = cursorList[s_id]
                    if (tcur==nil){
                        return;
                    }
                    
                    if (!(tcur!.xpos==xpos) || !(tcur!.ypos==ypos) || !(tcur!.x_speed==xspeed) || !(tcur!.y_speed==yspeed) || !(tcur!.motion_accel==maccel)) {
                        
                        let updateCursor =  TuioCursor(si: s_id,ci: tcur!.getCursorID(),xp: xpos,yp: ypos);
                        updateCursor.update(xp: xpos,yp: ypos,xs: xspeed,ys: yspeed,ma: maccel);
                        frameCursors.append(updateCursor);
                    }
                }
                
            } else if (command == "alive") {
                newCursorList.removeAll()
                
                
                for i in 1 ..< args.count  {
                    
                    // get the message content
                    let s_id = args[i] as! CLong
                    newCursorList.append(s_id)
                    
                    // reduce the cursor list to the lost cursors
                    aliveCursorList.delete(element: s_id)
                    
                    
                }
                // remove the remaining cursors
                for i in 0 ..< aliveCursorList.count  {
                    let removeCursor = cursorList[aliveCursorList[i]]
                    
                    if (!(removeCursor==nil)) {
                        removeCursor!.remove(ttime: currentTime!);
                        frameCursors.append(removeCursor!)
                        
                    }
                }
                //
                
                
            } else  if (command  == "fseq"){
                
                let fseq  = args[1] as! Int;
                var lateFrame = false;
                
                if (fseq>0) {
                    if (fseq>currentFrame) {
                        currentTime = TuioTime.getSessionTime();
                    }
                    if ((fseq>=currentFrame) || ((currentFrame-fseq)>100)){
                        currentFrame = fseq;
                    }  else {
                        lateFrame = true;
                    }
                } else if (TuioTime.getSessionTime().subtract(ttime: currentTime!).getTotalMilliseconds()>100) {
                    currentTime = TuioTime.getSessionTime();
                }
                if (!lateFrame) {
                    for tcur in frameCursors{
                        switch tcur.getTuioState() {
                        case TuioCursor.TUIO_REMOVED:
                            let removeCursor = tcur;
                            removeCursor.remove(ttime: currentTime!);
                            
                            
                            for listener in listenerList{
                                
                                if (!(listener==nil)) {
                                    listener.removeTuioCursor(tcur: removeCursor);
                                }
                            }
                            
                            if (removeCursor.getCursorID()==maxCursorID) {
                                maxCursorID = -1;
                                if (cursorList.count>0) {
                                    
                                    for tempcur in cursorList.values{
                                        let c_id = tempcur.getCursorID();
                                        if (c_id>maxCursorID) {
                                            maxCursorID=c_id;
                                        }
                                    }
                                    
                                    for fcur in freeCursorList{
                                        if (fcur.getCursorID()>=maxCursorID) {
                                            
                                            let index = freeCursorList.index(where: { (item) -> Bool in
                                                item.getCursorID() == fcur.getCursorID()
                                            })
                                            freeCursorList.remove(at: index!)
                                            
                                        }
                                    }
                                    
                                } else{
                                    freeCursorList.removeAll();
                                }
                            } else if (removeCursor.getCursorID()<maxCursorID) {
                                freeCursorList.append(removeCursor);
                            }
                            
                            break;
                        case TuioCursor.TUIO_ADDED:
                            
                            var c_id=cursorList.count
                            
                            if ((cursorList.count <= maxCursorID) && (freeCursorList.count>0)){
                                var closestCursor = freeCursorList.first;
                                
                                
                                //                            Enumeration<TuioCursor> testList = freeCursorList.elements();
                                //                            while (testList.hasMoreElements()) {
                                //                                TuioCursor testCursor = testList.nextElement();
                                //                                if (testCursor.getDistance(tcur)<closestCursor.getDistance(tcur)) closestCursor = testCursor;
                                //                            }
                                //                            c_id = closestCursor.getCursorID();
                                //                            freeCursorList.removeElement(closestCursor);
                                //                        } else maxCursorID = c_id;
                                //
                                //                        TuioCursor addCursor = new TuioCursor(currentTime,tcur.getSessionID(),c_id,tcur.getX(),tcur.getY());
                                //                        cursorList.put(addCursor.getSessionID(),addCursor);
                                //
                                
                                //                        for (int i=0;i<listenerList.size();i++) {
                                //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                                //                            if (listener!=null) listener.addTuioCursor(addCursor);
                                //                        }
                                
                                //                        break;
                                //
                                //                    default:
                                //
                                //                        TuioCursor updateCursor = cursorList.get(tcur.getSessionID());
                                //                        if ( (tcur.getX()!=updateCursor.getX() && tcur.getXSpeed()==0) || (tcur.getY()!=updateCursor.getY() && tcur.getYSpeed()==0) )
                                //                        updateCursor.update(currentTime,tcur.getX(),tcur.getY());
                                //                        else
                                //                        updateCursor.update(currentTime,tcur.getX(),tcur.getY(),tcur.getXSpeed(),tcur.getYSpeed(),tcur.getMotionAccel());
                                //
                                //                        for (int i=0;i<listenerList.size();i++) {
                                //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                                //                            if (listener!=null) listener.updateTuioCursor(updateCursor);
                                //                        }
                                //                    }
                                //                }
                                //
                                //                for (int i=0;i<listenerList.size();i++) {
                                //                    TuioListener listener = (TuioListener)listenerList.elementAt(i);
                                //                    if (listener!=null) listener.refresh(new TuioTime(currentTime,fseq));
                            }
                            //
                            //                Vector<Long> buffer = aliveCursorList;
                            //                aliveCursorList = newCursorList;
                            //                // recycling the vector
                            //                newCursorList = buffer;
                            break
                            
                        default:
                            break;
                        }
                    }
                    
                    
                    
                    
                }
                
                frameCursors.removeAll();
            }
            
            
            //-------------------Handle 2Dblb---------------------------
            
        } else if (address == "/tuio/2Dblb") {
            
            
            if (command  == "set"){
                //
                //            long s_id  = ((Integer)args[1]).longValue();
                //            float xpos = ((Float)args[2]).floatValue();
                //            float ypos = ((Float)args[3]).floatValue();
                //            float angle = ((Float)args[4]).floatValue();
                //            float width = ((Float)args[5]).floatValue();
                //            float height = ((Float)args[6]).floatValue();
                //            float area = ((Float)args[7]).floatValue();
                //            float xspeed = ((Float)args[8]).floatValue();
                //            float yspeed = ((Float)args[9]).floatValue();
                //            float rspeed = ((Float)args[10]).floatValue();
                //            float maccel = ((Float)args[11]).floatValue();
                //            float raccel = ((Float)args[12]).floatValue();
                //
                //            if (blobList.get(s_id) == null) {
                //
                //                TuioBlob addBlob = new TuioBlob(s_id, -1 ,xpos,ypos,angle,width,height,area);
                //                frameBlobs.addElement(addBlob);
                //
                //            } else {
                //
                //                TuioBlob tblb = blobList.get(s_id);
                //                if (tblb==null) return;
                //                if ((tblb.xpos!=xpos) || (tblb.ypos!=ypos) || (tblb.x_speed!=xspeed) || (tblb.y_speed!=yspeed) || (tblb.motion_accel!=maccel)) {
                //
                //                    TuioBlob updateBlob = new TuioBlob(s_id,tblb.getBlobID(),xpos,ypos,angle,width,height,area);
                //                    updateBlob.update(xpos,ypos,angle,width,height,area,xspeed,yspeed,rspeed,maccel,raccel);
                //                    frameBlobs.addElement(updateBlob);
                //                }
                //            }
                //
                //            //System.out.println("set blb " + s_id+" "+xpos+" "+ypos+" "+xspeed+" "+yspeed+" "+maccel);
                //
            } else  if (command  == "alive"){
                //
                //            newBlobList.clear();
                //            for (int i=1;i<args.length;i++) {
                //                // get the message content
                //                long s_id = ((Integer)args[i]).longValue();
                //                newBlobList.addElement(s_id);
                //                // reduce the blob list to the lost blobs
                //                if (aliveBlobList.contains(s_id))
                //                aliveBlobList.removeElement(s_id);
                //            }
                //
                //            // remove the remaining blobs
                //            for (int i=0;i<aliveBlobList.size();i++) {
                //                TuioBlob removeBlob = blobList.get(aliveBlobList.elementAt(i));
                //                if (removeBlob==null) continue;
                //                removeBlob.remove(currentTime);
                //                frameBlobs.addElement(removeBlob);
                //            }
                //
            } else  if (command  == "fseq"){
                
                let fseq  = args[1] as! Int;
                var lateFrame = false;
                
                if (fseq>0) {
                    if (fseq>currentFrame) {
                        currentTime = TuioTime.getSessionTime();
                    }
                    if ((fseq>=currentFrame) || ((currentFrame-fseq)>100)){
                        currentFrame = fseq;
                    }  else {
                        lateFrame = true;
                    }
                } else if (TuioTime.getSessionTime().subtract(ttime: currentTime!).getTotalMilliseconds()>100) {
                    currentTime = TuioTime.getSessionTime();
                }
                
                if (!lateFrame) {
                    //
                    //                Enumeration<TuioBlob> frameEnum = frameBlobs.elements();
                    //                while(frameEnum.hasMoreElements()) {
                    //                    TuioBlob tblb = frameEnum.nextElement();
                    //
                    //                    switch (tblb.getTuioState()) {
                    //                    case TuioBlob.TUIO_REMOVED:
                    //
                    //                        TuioBlob removeBlob = tblb;
                    //                        removeBlob.remove(currentTime);
                    //
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.removeTuioBlob(removeBlob);
                    //                        }
                    //
                    //                        blobList.remove(removeBlob.getSessionID());
                    //
                    //                        if (removeBlob.getBlobID()==maxBlobID) {
                    //                            maxBlobID = -1;
                    //                            if (blobList.size()>0) {
                    //                                Enumeration<TuioBlob> blist = blobList.elements();
                    //                                while (blist.hasMoreElements()) {
                    //                                    int b_id = blist.nextElement().getBlobID();
                    //                                    if (b_id>maxBlobID) maxBlobID=b_id;
                    //                                }
                    //
                    //                                Enumeration<TuioBlob> flist = freeBlobList.elements();
                    //                                while (flist.hasMoreElements()) {
                    //                                    TuioBlob fblb = flist.nextElement();
                    //                                    if (fblb.getBlobID()>=maxBlobID) freeBlobList.removeElement(fblb);
                    //                                }
                    //                            } else freeBlobList.clear();
                    //                        } else if (removeBlob.getBlobID()<maxBlobID) {
                    //                            freeBlobList.addElement(removeBlob);
                    //                        }
                    //
                    //                        break;
                    //
                    //                    case TuioBlob.TUIO_ADDED:
                    //
                    //                        int b_id = blobList.size();
                    //                        if ((blobList.size()<=maxBlobID) && (freeBlobList.size()>0)) {
                    //                            TuioBlob closestBlob = freeBlobList.firstElement();
                    //                            Enumeration<TuioBlob> testList = freeBlobList.elements();
                    //                            while (testList.hasMoreElements()) {
                    //                                TuioBlob testBlob = testList.nextElement();
                    //                                if (testBlob.getDistance(tblb)<closestBlob.getDistance(tblb)) closestBlob = testBlob;
                    //                            }
                    //                            b_id = closestBlob.getBlobID();
                    //                            freeBlobList.removeElement(closestBlob);
                    //                        } else maxBlobID = b_id;
                    //
                    //                        TuioBlob addBlob = new TuioBlob(currentTime,tblb.getSessionID(),b_id,tblb.getX(),tblb.getY(),tblb.getAngle(),tblb.getWidth(),tblb.getHeight(),tblb.getArea());
                    //                        blobList.put(addBlob.getSessionID(),addBlob);
                    //
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.addTuioBlob(addBlob);
                    //                        }
                    //                        break;
                    //
                    //                    default:
                    //
                    //                        TuioBlob updateBlob = blobList.get(tblb.getSessionID());
                    //                        if ( (tblb.getX()!=updateBlob.getX() && tblb.getXSpeed()==0) || (tblb.getY()!=updateBlob.getY() && tblb.getYSpeed()==0) )
                    //                        updateBlob.update(currentTime,tblb.getX(),tblb.getY(),tblb.getAngle(),tblb.getWidth(),tblb.getHeight(),tblb.getArea());
                    //                        else
                    //                        updateBlob.update(currentTime,tblb.getX(),tblb.getY(),tblb.getAngle(),tblb.getWidth(),tblb.getHeight(),tblb.getArea(),tblb.getXSpeed(),tblb.getYSpeed(),tblb.getRotationSpeed(),tblb.getMotionAccel(),tblb.getRotationAccel());
                    //
                    //                        for (int i=0;i<listenerList.size();i++) {
                    //                            TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                            if (listener!=null) listener.updateTuioBlob(updateBlob);
                    //                        }
                    //                    }
                    //                }
                    //
                    //                for (int i=0;i<listenerList.size();i++) {
                    //                    TuioListener listener = (TuioListener)listenerList.elementAt(i);
                    //                    if (listener!=null) listener.refresh(new TuioTime(currentTime,fseq));
                    //                }
                    //
                    //                Vector<Long> buffer = aliveBlobList;
                    //                aliveBlobList = newBlobList;
                    //                // recycling the vector
                    //                newBlobList = buffer;
                    //            }
                    //
                    frameBlobs.removeAll();
                }
                //
                //    }
                //}
            }
        }
    }
}
extension Array where Element: Equatable  {
    mutating func delete(element: Iterator.Element) {
        self = self.filter{$0 != element }
    }
}
