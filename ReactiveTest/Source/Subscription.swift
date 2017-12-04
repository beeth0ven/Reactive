//
//  Subscription.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/26.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public struct Subscription {
    
    public let subscribeAt: VirtualTimeScheduler.VirtualTime
    public let disposeAt: VirtualTimeScheduler.VirtualTime?
    
    init(_ subscribeAt: VirtualTimeScheduler.VirtualTime, _ disposeAt: VirtualTimeScheduler.VirtualTime? = nil) {
        self.subscribeAt = subscribeAt
        self.disposeAt = disposeAt
    }
}

extension Subscription: Equatable {
    public static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.subscribeAt == rhs.subscribeAt
            && lhs.disposeAt == rhs.disposeAt
    }
}
