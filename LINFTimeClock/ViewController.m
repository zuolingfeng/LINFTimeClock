//
//  ViewController.m
//  LINFTimeClock
//
//  Created by Linf on 15/6/4.
//  Copyright (c) 2015年 Linf. All rights reserved.
//

#import "ViewController.h"
#import "TimeView.h"

#define WIDTH       [UIScreen mainScreen].bounds.size.width
#define HEIGHT      [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TimeView *timeView = [[TimeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH, HEIGHT)];
    [self.view addSubview:timeView];
}

@end
