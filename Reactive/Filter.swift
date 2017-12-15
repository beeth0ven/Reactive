//
//  Filter.swift
//  Reactive
//
//  Created by luojie on 2017/12/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension ObservableType {
    
    public func filter(_ predicate: @escaping (Element) throws -> Bool) -> AnyObservable<Element> {
        
        return AnyObservable.create { [source = self, predicate] observer in
            
            let sourceDisposer = source.subscribe(AnyObserver { [predicate, observer] event in
                switch event {
                case .next(let element):
                    do {
                        let shouldEmmit = try predicate(element)
                        if shouldEmmit {
                            observer.on(.next(element))
                        }
                    } catch {
                        observer.on(.error(error))
                    }
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            })
            
            return sourceDisposer
        }
    }
}
