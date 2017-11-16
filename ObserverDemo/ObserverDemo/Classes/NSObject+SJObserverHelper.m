//
//  NSObject+SJObserverHelper.m
//  ObserverDemo
//
//  Created by BlueDancer on 2017/11/16.
//  Copyright © 2017年 BlueDancer. All rights reserved.
//

#import "NSObject+SJObserverHelper.h"
#import <objc/message.h>

@interface SJObserverHelper : NSObject
@property (nonatomic, assign) BOOL removed;
@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, unsafe_unretained) id observer;
@property (nonatomic, assign) NSString *assKey;
@property (nonatomic, strong) NSString *keyPath;
@end
@implementation SJObserverHelper @end

@interface SJFactor : NSObject
@property (nonatomic, strong) SJObserverHelper *tmp;
@end

@implementation SJFactor
- (void)dealloc {
    if ( !_tmp.removed ) {
        [_tmp.target removeObserver:_tmp.observer forKeyPath:_tmp.keyPath];
        _tmp.removed = YES;
    }
}
@end



static NSMutableDictionary<id, NSString *> *asskeysM;
@implementation NSObject (SJObserverHelper)

+ (void)load {
    asskeysM = [NSMutableDictionary new];
    Method method = class_getInstanceMethod([self class], @selector(addObserver:forKeyPath:options:context:));
    Method sjMethod = class_getInstanceMethod([self class], @selector(_sjaddObserver:forKeyPath:options:context:));
    method_exchangeImplementations(method, sjMethod);
    
    method = class_getInstanceMethod([self class], @selector(removeObserver:forKeyPath:));
    sjMethod = class_getInstanceMethod([self class], @selector(_sjremoveObserver:forKeyPath:));
    method_exchangeImplementations(method, sjMethod);
}

- (void)_sjaddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if ( !observer || !keyPath ) return;
    NSString *assKey = asskeysM[_sjassmap(observer, keyPath)];
    if ( assKey ) return;
    SJObserverHelper *helper = [SJObserverHelper new];
    helper.target = self;
    helper.observer = observer;
    helper.keyPath = keyPath;
    helper.assKey = _sjassmap(observer, keyPath);
    
    SJFactor *f1 = [SJFactor new];
    f1.tmp = helper;
    
    SJFactor *f2 = [SJFactor new];
    f2.tmp = helper;
    
    [asskeysM setObject:helper.assKey forKey:helper.assKey];
    
    objc_setAssociatedObject(self, (__bridge void *)helper.assKey, f1, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(observer, (__bridge void *)helper.assKey, f2, OBJC_ASSOCIATION_RETAIN);
    [self _sjaddObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)_sjremoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ( !observer || !keyPath ) return;
    NSString *dictKey = _sjassmap(observer, keyPath);
    NSString *assKey = asskeysM[dictKey];
    if ( !assKey ) return;
    SJFactor *f = objc_getAssociatedObject(observer, (__bridge void *)assKey);
    f.tmp.removed = YES;
    [asskeysM removeObjectForKey:dictKey];
    [self _sjremoveObserver:observer forKeyPath:keyPath];
}

inline static NSString *_sjassmap(id obj, NSString *keyPath) {
    return [NSString stringWithFormat:@"%zd%@1234", [obj hash], keyPath];
}

@end
