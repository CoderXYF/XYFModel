//
//  NSObject+Property.m
//  Runtime运用
//
//  Created by Mac on 2018/6/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

static const char *key = "name";

#import "NSObject+Property.h"
#import <objc/message.h>

@implementation NSObject (Property)

- (NSString *)name {
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
