//
//  ViewController.m
//  ObserverDemo
//
//  Created by BlueDancer on 2017/11/7.
//  Copyright © 2017年 BlueDancer. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Observer.h"
#import <objc/message.h>

@interface ViewController ()

@property (nonatomic, strong) Person *xiao;

@property (nonatomic, strong) Observer *observer;

@property (nonatomic, strong) Observer *observer2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _xiao = [Person new];
    _observer = [Observer  new];


    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)change:(id)sender {
    _xiao.name = [NSString stringWithFormat:@"%zd", arc4random() % 10];
}

- (IBAction)nill:(id)sender {
    NSLog(@"%zd - %s", __LINE__, __func__);
    _observer = nil;
}

- (IBAction)personNil:(id)sender {
    NSLog(@"%zd - %s", __LINE__, __func__);
    _xiao = nil;
}

- (IBAction)add:(id)sender {
    NSLog(@"%zd - %s", __LINE__, __func__);
    [_xiao addObserver:_observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [_xiao addObserver:_observer forKeyPath:@"name2" options:NSKeyValueObservingOptionNew context:nil];
}

- (IBAction)remove:(id)sender {
    NSLog(@"%zd - %s", __LINE__, __func__);
    [_xiao removeObserver:_observer forKeyPath:@"name"];
}

- (IBAction)create:(id)sender {
    NSLog(@"%zd - %s", __LINE__, __func__);
    _xiao = [Person new];
    _observer = [Observer  new];
}

- (IBAction)query:(id)sender {
    NSLog(@"%@ - %@", _xiao, _observer);
}

- (void)dealloc {
    NSLog(@"%zd - %s", __LINE__, __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
