//
//  DispatchQueueScheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/14.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public struct DispatchQueueScheduler {
    
    fileprivate let _dispatchQueue: DispatchQueue
    
    public init(_ dispatchQueue: DispatchQueue) {
        _dispatchQueue = dispatchQueue
    }
}

extension DispatchQueueScheduler: SchedulerType {
    
    public func async(_ execute: @escaping () -> Void) {
        _dispatchQueue.async(execute: execute)
    }
}
