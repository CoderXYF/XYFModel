//
//  MyClass.m
//  Runtime运用
//
//  Created by Mac on 2018/6/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyClass.h"

@implementation MyClass

- (instancetype)init {
    self = [super init];
    if (self) {
        [self showUserName];
    }
    return self;
}

- (void)showUserName {
    NSLog(@"Dave Ping");
}

@end
