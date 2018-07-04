//
//  UIControl+ClickBlock.m
//  Runtime运用
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UIControl+ClickBlock.h"
#import <objc/message.h>

static const void *associatedKey = "associatedKey";

@implementation UIControl (ClickBlock)

- (void)setClick:(ClickBlock)click {
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (ClickBlock)click {
    return objc_getAssociatedObject(self, associatedKey);
}

- (void)buttonClick {
    if (self.click) {
        self.click(self);
    }
}

//- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
//
//}

- (id)valueForUndefinedKey:(NSString *)key {
    return @"888";
}

@end
