//
//  ViewController.m
//  TmpProject
//
//  Created by BlueDancer on 2017/12/8.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Observer.h"
#import "NSObject+SJObserverHelper.h"
#import <objc/message.h>
#import "TestViewController.h"

@interface ViewController ()

@property (nonatomic, strong) Person *xiaoM;
@property (nonatomic, strong) Observer *observer;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    Person *x1 = [Person new];
    
    x1.name = @"san";
    x1.name = @"san2";

    sjkvo_observe(x1, @"name", ^(id  _Nonnull target, NSDictionary<NSKeyValueChangeKey,id> * _Nullable change) {
        NSLog(@"观察者1号: %@", change);
    });
    
    NSInteger identifier2 = sjkvo_observe(x1, @"name", ^(id  _Nonnull target, NSDictionary<NSKeyValueChangeKey,id> * _Nullable change) {
        NSLog(@"观察者2号: %@", change);
    });
    
    x1.name = @"a";
    x1.name = @"b";
    x1.name = @"c";
    
    sjkvo_remove(x1, identifier2);
    
    x1.name = @"d";
    x1.name = @"e";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)test:(id)sender {
    [self presentViewController:[TestViewController new] animated:YES completion:nil];
}

- (IBAction)added:(id)sender {
    if ( !_xiaoM ) [self createP:nil];
    if ( !_observer ) [self createO:nil];
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    [_xiaoM sj_addObserver:_observer forKeyPath:@"name"];
}

- (IBAction)change:(id)sender {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    _xiaoM.name = @"dsf";
}
- (IBAction)personnil:(id)sender {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    _xiaoM = nil;
}
- (IBAction)observernil:(id)sender {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    _observer = nil;
}
- (IBAction)createP:(id)sender {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    _xiaoM = [Person new];
    NSLog(@"%@", _xiaoM);
}
- (IBAction)createO:(id)sender {
    NSLog(@"%d - %s", (int)__LINE__, __func__);
    _observer = [Observer new];
}


@end
