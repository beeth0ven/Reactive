//
//  Observable+Map.swift
//  Reactive
//
//  Created by luojie on 2017/11/12.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension ObservableType {
    
    public func map<R>(_ transform: @escaping (Element) throws -> R) -> AnyObservable<R> {
        
        return AnyObservable<R>.create { [source = self, transform] observer in
            
            let _sourceDisposer = source.subscribe(AnyObserver { [transform, observer] event in
                switch event {
                case .next(let element):
                    do {
                        let mappedElement = try transform(element)
                        observer.on(.next(mappedElement))
                    } catch {
                        observer.on(.error(error))
                    }
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            })
            
            return _sourceDisposer
        }
    }
}

