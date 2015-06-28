//
//  NSObject+observer.m
//  testCollectionView
//
//  Created by shenqiang on 15/5/8.
//  Copyright (c) 2015年 shenqiang. All rights reserved.
//

#import "NSObject+observer.h"
#import <objc/runtime.h>

#define CHANGE_CALLBACK  @"changeCallBack"
#define KEYPATHS @"keypaths"
#define KEYPATH_DICITIONARY @"keypath_dictionary"

@implementation NSObject (observer)

static void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
{
    
    Method origMethod = class_getInstanceMethod(c, origSEL);
    
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);

    method_exchangeImplementations(origMethod, overrideMethod);
    
    
}

+(void)load{
    
    MethodSwizzle([self class], @selector(sq_observeValueForKeyPath: ofObject: change:context:), @selector(observeValueForKeyPath: ofObject: change: context:));
}

-(void)sq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context changeCallBack:(observerChangeCallBack)changeCallBack{
    
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
    
    NSMutableDictionary *keypathDictionary = objc_getAssociatedObject(observer, KEYPATH_DICITIONARY);
    if (!keypathDictionary) {
        keypathDictionary = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(observer, KEYPATH_DICITIONARY, keypathDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [keypathDictionary setObject:changeCallBack forKey:keyPath];
    
    
}

- (void)sq_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSMutableDictionary *keypathDictionary = (NSMutableDictionary*)objc_getAssociatedObject(self, KEYPATH_DICITIONARY);
    
    if ([keypathDictionary objectForKey:keyPath]) {
        
      observerChangeCallBack callback =  (observerChangeCallBack)[keypathDictionary objectForKey:keyPath];
      
      callback(keyPath,object,change,context);
       
        
    }else if([self respondsToSelector:@selector(observeValueForKeyPath: ofObject: change: context:)]){
        
    }
    
    
}

@end
