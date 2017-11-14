//
//  Scheduler.swift
//  Reactive
//
//  Created by luojie on 2017/11/14.
//  Copyright © 2017年 LuoJie. All rights reserved.
//


public enum Scheduler {
    
    public static let main = DispatchQueueScheduler(.main)
    public static let userInitiated = DispatchQueueScheduler(.global(qos: .userInitiated))
}
