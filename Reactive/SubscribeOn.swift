//
//  SubscribeOn.swift
//  Reactive
//
//  Created by luojie on 2017/11/15.
//  Copyright © 2017年 LuoJie. All rights reserved.
//

extension Observable {
    
    public func subscribeOn(_ scheduler: Scheduler) -> Observable<E> {
        
        return Observable { [source = self, scheduler] observer in
            let _disposer = Disposable()
            scheduler.async {
                let disposable = source.subscribe(observer)
                _disposer.setDispose(disposable.dispose)
            }
            return _disposer
        }
    }
}

extension Observable {
    
    public func observeOn(_ scheduler: Scheduler) -> Observable<E> {
        
        return Observable { [source = self, scheduler] observer in
            let _sourceDisposer = source.subscribe(Observer { event in
                scheduler.async { observer.on(event) }
            })
            return _sourceDisposer
        }
    }
}
