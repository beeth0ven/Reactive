//
//  Subscription.swift
//  ReactiveTest
//
//  Created by luojie on 2017/11/26.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Reactive

public class Subscription: Disposable {
    
    public let subscribeAt: VirtualTimeScheduler.VirtualTime
    public private(set) var disposeAt: VirtualTimeScheduler.VirtualTime?
    
    private let _scheduler: VirtualTimeScheduler
    private var _isDisposed = false
    private let _dispose: () -> Void

    public init(scheduler: VirtualTimeScheduler, dispose: @escaping () -> Void = {}) {
        _scheduler = scheduler
        subscribeAt = scheduler.clock
        _dispose = dispose
    }
    
    public func dispose() {
        guard !_isDisposed else { return }
        _isDisposed = true
        disposeAt = _scheduler.clock
        _dispose()
    }
}

extension Subscription: Equatable {
    public static func ==(lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.subscribeAt == rhs.subscribeAt
            && lhs.disposeAt == rhs.disposeAt
    }
}

