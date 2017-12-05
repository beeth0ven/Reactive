//
//  MergeTests.swift
//  ReactiveTests
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class MergeTests: XCTestCase {
    
    func testExample() {
        
        let source0 = AnyObservable<String> { observer in
            observer.on(.next("Source0 0"))
            observer.on(.next("Source0 1"))
            observer.on(.next("Source0 2"))
            observer.on(.completed)
            observer.on(.next("Source0 3"))
            return Disposer {
                print("$: Dispose Source0")
            }
        }
        
        let source1 = AnyObservable<String> { observer in
            observer.on(.next("source1 0"))
            observer.on(.next("source1 1"))
            observer.on(.next("source1 2"))
            observer.on(.completed)
            observer.on(.next("source1 3"))
            return Disposer {
                print("$: Dispose source1")
            }
        }
        
        let merged = AnyObservable.merge(source0, source1)
        
        let observer = AnyObserver<String> { event in
            switch event {
            case .next(let element):
                print("$: next:", element)
            case .error(let error):
                print("$: error:", error)
            case .completed:
                print("$: completed")
            }
        }
        
        let disposable = merged.subscribe(observer)
        
    }
}
