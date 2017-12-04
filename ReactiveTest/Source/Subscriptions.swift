//
//  Subscriptions.swift
//  ReactiveTest
//
//  Created by luojie on 2017/12/4.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation

public struct Subscriptions {
    
    public private(set) var subscriptions: [Subscription]
    
    init(subscriptions: [Subscription] = []) {
        self.subscriptions = subscriptions
    }
    
    public mutating func addNewSubscription(atTime time: VirtualTimeScheduler.VirtualTime) -> Int {
        let index = subscriptions.endIndex
        subscriptions.append(Subscription(time))
        return index
    }
    
    public mutating func dispose(atIndex index: Int, atTime time: VirtualTimeScheduler.VirtualTime) {
        let subscription = subscriptions[index]
        subscriptions[index] = Subscription(subscription.subscribeAt, time)
    }
}

extension Subscriptions: Equatable {
    
    public static func ==(lhs: Subscriptions, rhs: Subscriptions) -> Bool {
        return lhs.subscriptions == rhs.subscriptions
    }
}

extension Subscriptions: ExpressibleByArrayLiteral {
    
    public typealias ArrayLiteralElement = Subscription
    
    public init(arrayLiteral elements: Subscription...) {
        self.init(subscriptions: elements)
    }
}
