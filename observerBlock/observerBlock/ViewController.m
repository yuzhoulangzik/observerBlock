//
//  ViewController.m
//  observerBlocks
//
//  Created by 沈强 on 15/6/22.
//  Copyright (c) 2015年 沈强. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "People.h"
#import "NSObject+observer.h"
@interface ViewController (){
    People * anything ;
    People * x;
    People * y;
    People * xy;
    People * control;
}

@end

@implementation ViewController

static NSArray * ClassMethodNames(Class c)
{
    NSMutableArray * array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList(c, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++) {
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    }
    
    free(methodList);
    
    return array;
}



static void PrintDescription(NSString * name, NSObject* obj)
{
    
    NSString * str = [NSString stringWithFormat:
                      @"\n\t%@: %@\n\tNSObject class %s\n\tlibobjc class %s\n\timplements methods <%@>",
                      name,
                      
                      obj,
                      
                      class_getName([obj class]),
                      
                      class_getName(object_getClass(obj)),
                      
                      [ClassMethodNames(object_getClass(obj)) componentsJoinedByString:@", "]];
    
    
    NSLog(@"%@", str);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"TEST GIT");
    NSLog(@"TEST2 GIT");
    NSLog(@"test");
    anything = [[People alloc] init];
    x = [[People alloc] init];
    y = [[People alloc] init];
    xy = [[People alloc] init];
    control = [[People alloc] init];
    
    [x addObserver:anything forKeyPath:@"name" options:0 context:NULL];
//    [y addObserver:anything forKeyPath:@"age" options:0 context:NULL];
//    
//    [xy addObserver:anything forKeyPath:@"name" options:0 context:NULL];
//    [xy addObserver:anything forKeyPath:@"age" options:0 context:NULL];
    
    [x sq_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:NULL changeCallBack:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        NSLog(@"block keyPath == %@",keyPath);
    }];
    
    [x sq_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL changeCallBack:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        NSLog(@"block keyPath == %@",keyPath);
    }];
    
    PrintDescription(@"control", control);
    PrintDescription(@"x", x);
    PrintDescription(@"y", y);
    PrintDescription(@"xy", xy);
    
    NSLog(@"\n\tUsing NSObject methods, normal setX: is %p, overridden setX: is %p\n",
          [control methodForSelector:@selector(setName:)],
          [anything methodForSelector:@selector(setName:)]);
    NSLog(@"\n\tUsing libobjc functions, normal setX: is %p, overridden setX: is %p\n",
          method_getImplementation(class_getInstanceMethod([x class],
                                                           @selector(setName:))),
          method_getImplementation(class_getInstanceMethod(object_getClass(x),
                                                           @selector(setName:))));
    
    x.age = @"22";
    x.name = @"sq";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    NSLog(@"======================test");
}

@end

