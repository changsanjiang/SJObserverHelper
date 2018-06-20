//
//  Observer.m
//  TmpProject
//
//  Created by BlueDancer on 2017/12/8.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "Observer.h"

@implementation Observer

- (void)dealloc {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@", object);
}

@end
