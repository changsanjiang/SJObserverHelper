//
//  NSObject+SJObserverHelper.m
//  TmpProject
//
//  Created by BlueDancer on 2017/12/8.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "NSObject+SJObserverHelper.h"
#import <objc/message.h>

@interface SJObserverHelper : NSObject
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, unsafe_unretained) id observer;
@property (nonatomic, weak) SJObserverHelper *sub;
@property (nonatomic, copy) void(^deallocCallBlock)(SJObserverHelper *tmpObj);
@end

@implementation SJObserverHelper
- (void)dealloc {
    NSLog(@"%zd - %s", __LINE__, __func__);
    if ( _deallocCallBlock ) _deallocCallBlock(self);
}
@end



@implementation NSObject (ObserverHelper)

- (void)sj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    
    SJObserverHelper *tmp = [SJObserverHelper new];
    SJObserverHelper *sub = [SJObserverHelper new];
    
    sub.target = tmp.target = self;
    sub.observer = tmp.observer = observer;
    tmp.sub = sub;
    sub.sub = tmp;
    
    const char *tmpKey = [NSString stringWithFormat:@"%zd-%@", [observer hash], keyPath].UTF8String;
    objc_setAssociatedObject(self, tmpKey, tmp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, tmpKey, sub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    void(^deallocCallBlock)(SJObserverHelper *tmpObj) = ^(SJObserverHelper *tmpObj) {
        if ( tmpObj.sub ) {
            [tmpObj.target removeObserver:tmpObj.observer forKeyPath:keyPath];
        }
    };
    tmp.deallocCallBlock = deallocCallBlock;
    sub.deallocCallBlock = deallocCallBlock;
}

@end

