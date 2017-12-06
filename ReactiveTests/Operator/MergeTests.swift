//
//  MergeTests.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
import ReactiveTest
@testable import Reactive

class MergeTests: XCTestCase {
    
    func testExample() {
        
        let scheduler = VirtualTimeScheduler()
        
        let source0 = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(300, 0),
            .next(400, 1),
            .next(500, 2),
            .completed(600),
            .next(700, 0),
            ])
        
        let source1 = HotObservable(scheduler: scheduler, recordedEvents: [
            .next(350, 10),
            .next(450, 11),
            .next(550, 12),
            .completed(650),
            .next(750, 0),
            ])
        
        let observer = RecordObserver<Int>(scheduler: scheduler)
        
        scheduler.schedule(at: 200) {
            _ = AnyObservable.merge(
                source0.asObservable(),
                source1.asObservable()
                ).subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(300, 0),
            .next(350, 10),
            .next(400, 1),
            .next(450, 11),
            .next(500, 2),
            .next(550, 12),
            .completed(650),
            ])
        
        XCTAssertEqual(source0.subscriptions, [
            Subscription(200, 600)
            ])
        
        XCTAssertEqual(source1.subscriptions, [
            Subscription(200, 650)
            ])
    }
}
