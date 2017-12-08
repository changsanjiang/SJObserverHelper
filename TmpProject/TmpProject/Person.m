//
//  Person.m
//  TmpProject
//
//  Created by BlueDancer on 2017/12/8.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    NSLog(@"%zd - %s", __LINE__, __func__);
}

- (NSString *)description {
    return _name;
}
@end
