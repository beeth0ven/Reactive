//
//  OperationQueueScheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/14.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public struct OperationQueueScheduler {
    
    fileprivate let _operationQueue: OperationQueue
    
    public init(_ operationQueue: OperationQueue) {
        _operationQueue = operationQueue
    }
}

extension OperationQueueScheduler: SchedulerType {
    
    public func async(_ execute: @escaping () -> Void) {
        _operationQueue.addOperation(execute)
    }
}
