//
//  NSObject+observer.m
//  testCollectionView
//
//  Created by shenqiang on 15/5/8.
//  Copyright (c) 2015年 shenqiang. All rights reserved.
//

#import "NSObject+observer.h"
#import <objc/runtime.h>

#define CHANGE_CALLBACK  @"SQChangeCallBack"


@implementation NSObject (observer)

-(void)sq_addObserverHandlerForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context changeCallBack:(observerChangeCallBack)changeCallBack{
    [self addObserver:self forKeyPath:keyPath options:options context:context];
    objc_setAssociatedObject(self, CHANGE_CALLBACK, changeCallBack,  OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
          observerChangeCallBack callback =  (observerChangeCallBack)objc_getAssociatedObject(self, CHANGE_CALLBACK);
            if (callback) {
               callback(keyPath,object,change,context);
            }
}
@end
