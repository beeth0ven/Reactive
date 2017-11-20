//
//  SubscribeOn.swift
//  Reactive
//
//  Created by luojie on 2017/11/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension AnyObservable {
    
    public func subscribeOn(_ scheduler: Scheduler) -> AnyObservable<E> {
        
        return AnyObservable { [source = self, scheduler] observer in
            let _disposer = Disposable()
            scheduler.async { [source, observer, _disposer] in
                let disposable = source.subscribe(observer)
                _disposer.setDispose(disposable.dispose)
            }
            return _disposer
        }
    }
}

extension AnyObservable {
    
    public func observeOn(_ scheduler: Scheduler) -> AnyObservable<E> {
        
        return AnyObservable { [source = self, scheduler] observer in
            let _sourceDisposer = source.subscribe(AnyObserver { [scheduler, observer] event in
                scheduler.async {
                    observer.on(event)
                }
            })
            return _sourceDisposer
        }
    }
}
