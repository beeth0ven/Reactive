//
//  MapTest.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
import ReactiveTest
@testable import Reactive

class MapTests: XCTestCase {
    
    func testExample() {
        
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
            _ = observable.asObservable()
                .map { $0 * 2 }
                .subscribe(observer)
        }
        scheduler.start()
        
        XCTAssertEqual(observer.recordedEvents, [
            .next(300, 0 * 2),
            .next(400, 1 * 2),
            .next(500, 2 * 2),
            .completed(600)
            ])
        
        XCTAssertEqual(observable.subscriptions, [
            Subscription(200, 600)
            ])
    }
}
