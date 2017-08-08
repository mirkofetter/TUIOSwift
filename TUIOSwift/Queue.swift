//
//  Queue.swift
//  TUIOSwift
//
//  Created by Mirko Fetter on 21.02.17.
//  Copyright © 2017 grugru. All rights reserved.
//

import Foundation


private class Node<T> {
    let data: T
    var next: Node?
    
    init(data: T) {
        self.data = data
    }
}

class Queue<T> {
    
    var size:Int=0;
    
    private var head: Node<T>?
    private var tail: Node<T>?
    
    func enqueue(e: T) {
        let node = Node(data: e)
        if let lastNode = tail {
            lastNode.next = node
        } else {
            head = node
        }
        tail = node
        size+=1;
    }
    
    
    func addLast(e: T) {
        enqueue(e: e)
    }

  
    
    func dequeue() -> T? {
        if let firstNode = head {
            head = firstNode.next
            if head == nil {
                tail = nil
            }
            size-=1;
            return firstNode.data

        } else {
            return nil
        }
    }
    
    func removeFirst() -> T? {
        return dequeue()
    }
    
    //Retrieves, but does not remove, the first element of this deque.
    
    func getFirst() ->T?{
        return head?.data
    }
    
    //Retrieves, but does not remove, the last element of this deque.
    func getLast() ->T?{
        return tail?.data
    }
    
}
