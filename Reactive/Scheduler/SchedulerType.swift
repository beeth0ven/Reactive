//
//  SchedulerType.swift
//  Reactive
//
//  Created by luojie on 2017/11/14.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public protocol SchedulerType {
    func async(_ execute: @escaping () -> Void)
}
