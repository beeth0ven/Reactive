//
//  Scheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/14.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public struct Scheduler {
    
    fileprivate let _dispatchQueue: DispatchQueue
    
    public init(_ dispatchQueue: DispatchQueue) {
        _dispatchQueue = dispatchQueue
    }
}

extension Scheduler {
    
    public func async(_ execute: @escaping () -> Void) {
        _dispatchQueue.async(execute: execute)
    }
}

extension Scheduler {
    
    public static let main = Scheduler(.main)
    public static let userInitiated = Scheduler(.global(qos: .userInitiated))
    public static let background = Scheduler(.global(qos: .background))
    public static let utility = Scheduler(.global(qos: .utility))
}
