//
//  ReactiveTests.swift
//  ReactiveTests
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
import ReactiveTest
@testable import Reactive


class Tests: XCTestCase {
    
    func test() {
        
        let scheduler = VirtualTimeScheduler()

        let observable = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(300, 0),
            .next(400, 1),
            .next(500, 2),
            .completed(600),
            .next(700, 0),
            ])
        
        let observer = RecordObserver<Int>(scheduler: scheduler)
        
        scheduler.schedule(at: 200) {
            _ = observable.asObservable().subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(300, 0),
            .next(400, 1),
            .next(500, 2),
            .completed(600),
            ])
        
        XCTAssertEqual(observable.subscriptions, [
            Subscription(200, 600)
            ])
        
    }
}

