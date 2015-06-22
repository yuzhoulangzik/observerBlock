//
//  NSObject+observer.h
//  testCollectionView
//
//  Created by shenqiang on 15/5/8.
//  Copyright (c) 2015年 shenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^observerChangeCallBack)(NSString *keyPath,
                                      id object,
                                      NSDictionary *change,
                                      void * context);
@interface NSObject (observer)
-(void)sq_addObserverHandlerForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context changeCallBack:(observerChangeCallBack)changeCallBack;
@end
