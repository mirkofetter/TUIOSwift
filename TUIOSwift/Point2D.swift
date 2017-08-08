//
//  Point2D.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 28.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation

struct Point2D {
    var x:Float, y:Float;
    
    init(x:Float, y:Float) {
        self.x=x
        self.y=y
    }
    
    func getX() -> Float{
        return x;
    }
    func getY() -> Float{
        return y;
    }
}
