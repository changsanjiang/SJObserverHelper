//
//  Person.m
//  ObserverDemo
//
//  Created by BlueDancer on 2017/11/7.
//  Copyright © 2017年 BlueDancer. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

- (void)dealloc {
    NSLog(@"%zd - %s", __LINE__, __func__);
}

@end
