//
//  VirtualTimeScheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/19.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class VirtualTimeScheduler {
    
    public typealias VirtualTime = Int
    public typealias Task = () -> Void
    public typealias ScheduledTask = (deadline: VirtualTime, task: Task)
    
    private var _clock: VirtualTime = 0
    private var _isRuning = false
    private var _scheduledTasks = SortedQueue<ScheduledTask>(sortBy: { $0.deadline < $1.deadline })
    
    public func schedule(at deadline: VirtualTime, task: @escaping Task) {
        _scheduledTasks.enqueue((deadline, task))
    }
    
    public func start() {
        guard !_isRuning else { return }
        _isRuning = true
        
        while let scheduledTask = _scheduledTasks.dequeue() {
            guard _clock <= scheduledTask.deadline else {
                fatalError("Schedule a task run at past time.")
            }
            _clock = scheduledTask.deadline
            scheduledTask.task()
        }
        
        _isRuning = false
    }
}
