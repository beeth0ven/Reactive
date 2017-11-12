//
//  Observable.swift
//  Reactive
//
//  Created by luojie on 2017/11/8.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

public class Observable<E> {
    
    public let subscribe: (Observer<E>) -> Disposable
    
    public init(_ subscribe: @escaping (Observer<E>) -> Disposable) {
        
        self.subscribe = { [subscribe] observer in
            
            let _disposer = Disposable()

            let _disposable = subscribe(Observer { [observer] event in
                guard !_disposer.isDisposed else { return }
                switch event {
                case .next(let element):
                    observer.on(.next(element))
                case .error(let error):
                    observer.on(.error(error))
                    _disposer.dispose()
                case .completed:
                    observer.on(.completed)
                    _disposer.dispose()
                }
            })
            
            _disposer.setDispose(_disposable.dispose)
            return _disposer
        }
    }
}


