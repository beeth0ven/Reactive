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
    
    func testSyncExample() {
        
        print("---------Before testSyncExample---------")
        
        let observable = Observable<Int> { observer in
            observer.on(.next(0))
            observer.on(.next(1))
            observer.on(.next(2))
            observer.on(.completed)
            observer.on(.next(3))
            return Disposable {
                print("Dispose")
            }
        }
        
        let observer = Observer<Int> { event in
            switch event {
            case .next(let value):
                print("next:", value)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }
        }
        
        let disposable = observable.subscribe(observer)
        
        //        disposable.dispose()
        
        print("---------After testSyncExample---------")
        
    }
    
    func testAsyncExample() {
        
        print("---------Before testAsyncExample---------")
        
        let observable = Observable<Int> { observer in
            DispatchQueue.main.async {
                print("---------Before testAsyncExample---------")
                observer.on(.next(0))
                observer.on(.next(1))
                observer.on(.next(2))
                observer.on(.completed)
                observer.on(.next(3))
                print("---------After testAsyncExample---------")
            }
            return Disposable {
                print("Dispose")
            }
        }
        
        let observer = Observer<Int> { event in
            switch event {
            case .next(let value):
                print("next:", value)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }
        }
        
        let disposable = observable.subscribe(observer)
        
        //        disposable.dispose()
        
        print("---------After testAsyncExample---------")
        
    }
}
