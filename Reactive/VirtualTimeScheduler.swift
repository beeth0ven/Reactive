//
//  VirtualTimeScheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public struct VirtualTimeScheduler {
    
    public typealias VirtualTime = Int
    public typealias Task = () -> Void
    
    private var _clock: VirtualTime = 0
    private var _isRuning = false
    private var _tasks: [(deadline: VirtualTime, task: Task)] = []
    
    public mutating func schedule(at deadline: VirtualTime, task: @escaping Task) {
        _tasks.append((deadline, task))
    }
    
    public mutating func start() {
        guard !_isRuning else { return }
        _isRuning = true
        _tasks
            .sorted(by: { $0.deadline < $1.deadline })
            .forEach { $0.task() }
        _isRuning = false
    }
}
