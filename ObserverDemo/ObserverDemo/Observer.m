//
//  Observer.m
//  ObserverDemo
//
//  Created by BlueDancer on 2017/11/7.
//  Copyright © 2017年 BlueDancer. All rights reserved.
//

#import "Observer.h"

@implementation Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"fdsfds");
}

- (void)dealloc {
//    NSLog(@"%@", self.observationInfo);
    NSLog(@"%zd - %s", __LINE__, __func__);
}

@end
