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
    
    init(subscribeAt: VirtualTimeScheduler.VirtualTime, disposeAt: VirtualTimeScheduler.VirtualTime? = nil) {
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

public struct Subscriptions {
    
    public private(set) var subscriptions: [Subscription] = []
    private let _scheduler: VirtualTimeScheduler
    
    init(scheduler: VirtualTimeScheduler) {
        _scheduler = scheduler
    }
    
    public mutating func addNewSubscription() -> Int {
        let index = subscriptions.endIndex
        subscriptions.append(Subscription(subscribeAt: _scheduler.clock))
        return index
    }
    
    public mutating func dispose(atIndex index: Int) {
        let subscription = subscriptions[index]
        subscriptions[index] = Subscription(subscribeAt: subscription.subscribeAt, disposeAt: _scheduler.clock)
    }
}
