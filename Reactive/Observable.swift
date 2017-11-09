//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

import Foundation

public class Observable<E> {
    
    public let subscribe: (Observer<E>) -> Disposable
    
    init(_ subscribe: @escaping (Observer<E>) -> Disposable) {
        
        let _disposer = Disposable()
        
        self.subscribe = { observer in
            
            let _sink = Observer<E> { event in
                guard !_disposer.isDisposed else { return }
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                case .error(let error):
                    observer.on(.error(error))
                    _disposer.dispose()
                case .completed:
                    observer.on(.completed)
                    _disposer.dispose()
                }
            }
            
            let _disposable = subscribe(_sink)
            _disposer.setDispose(_disposable.dispose)
            return _disposer
        }
    }
}
