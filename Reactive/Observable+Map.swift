//
//  Observable+Map.swift
//  Reactive
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension Observable {
    
    public func map<R>(_ transform: @escaping (E) -> R) -> Observable<R> {
        
        let _mapProducer = Observable<R> { [source = self, transform] observer in
            
            let _mapSink = Observer<E> { [transform, observer] event in
                switch event {
                case .next(let element):
                    let mappedElement = transform(element)
                    observer.on(.next(mappedElement))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
            
            let _sourceDisposer = source.subscribe(_mapSink)
            return _sourceDisposer
        }
        
        return _mapProducer
    }
}

