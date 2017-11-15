//
//  Merge.swift
//  Reactive
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension Observable {
    
    public static func merge(_ source0: Observable<E>, _ source1: Observable<E>) -> Observable<E> {
        
        return Observable<E> { [source0, source1] observer in
            
            var _completedCount = 0
            let increaseCompletedCount = { _completedCount += 1 }
            let allCompleted = { _completedCount == 2 }
            
            let _mergeObserver = Observer<E> { [observer] event in
                switch event {
                case .next(let element):
                    observer.on(.next(element))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    increaseCompletedCount()
                    if allCompleted() {
                        observer.on(.completed)
                    }
                }
            }
            
            let _sourceDisposer0 = source0.subscribe(_mergeObserver)
            let _sourceDisposer1 = source1.subscribe(_mergeObserver)
            
            return Disposable {
                _sourceDisposer0.dispose()
                _sourceDisposer1.dispose()
            }
        }
    }
}
