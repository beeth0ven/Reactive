//
//  SubscribeOn.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class SubscribeOnTest: XCTestCase {
    
    func testExample() {

        print("\(Thread.current.number) $: 0")

        let source = Observable<String> { observer in
            print("\(Thread.current.number) $: subscribeOn:")
            observer.on(.next("0"))
            observer.on(.next("1"))
            observer.on(.next("2"))
            observer.on(.completed)
            observer.on(.next("3"))
            return Disposable {
                print("\(Thread.current.number) $: Dispose")
            }
        }
        
        let observer = Observer<String> { event in
            switch event {
            case .next(let element):
                print("\(Thread.current.number) $: next:", element)
            case .error(let error):
                print("\(Thread.current.number) $: error:", error)
            case .completed:
                print("\(Thread.current.number) $: completed")
            }
        }
        
        let disposable = source
//            .subscribeOn(.userInitiated)
            .observeOn(.utility)
            .subscribe(observer)
//            .dispose()

        print("\(Thread.current.number) $: 1")

    }
}

extension Thread {
    var number: Int {
        return value(forKeyPath: "private.seqNum") as! Int
    }
}
