//
//  ReactiveTests.swift
//  ReactiveTests
//
//  Created by luojie on 2017/9/10.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import XCTest
@testable import Reactive

class ReactiveTests: XCTestCase {
    
    func testExample() {
        
        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
            observer.on(.next(0))
            observer.on(.next(1))
            observer.on(.next(2))
            observer.on(.next(3))
            observer.on(.next(4))
            observer.on(.completed)
            observer.on(.next(5))
            return Disposables.create {
                print("on Dispose.")
            }
        }
        
//        let doubled = map(numbers) { $0 * 2 }
        
        let disposable = numbers.subscribe(AnyObserver { event in
            switch event {
            case .next(let value):
                print("on Next:", value)
            case .error(let error):
                print("on Error:", error)
            case .completed:
                print("completed.")
            }
        })
        
        disposable.dispose()
    }
}
