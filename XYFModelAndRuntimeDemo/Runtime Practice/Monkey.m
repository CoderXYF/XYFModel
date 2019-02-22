//
//  Monkey.m
//  Runtime运用
//
//  Created by Mac on 2018/6/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "Monkey.h"
#import "Bird.h"
#import <objc/message.h>

@implementation Monkey

+ (NSString *)cvbnm:(NSInteger)num {
//    NSLog(@"%@, %zd", self, num);
    return [NSString stringWithFormat:@"%@---%zd", self, num];
}

- (void)jump {
    NSLog(@"Monkey can not fly, but, monkey can jump");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
#if 1
    return NO;
#else
    class_addMethod(self, sel, class_getMethodImplementation(self, sel_registerName("jump")), "v@:");
//    return [super resolveInstanceMethod:sel];
    return YES;
#endif
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
#if 1
    return nil;
#else
    return [[Bird alloc] init];
#endif
}

/*
 获取方法签名进入下一步，进行消息转发
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

/*
 消息转发
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:[[Bird alloc] init]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
}

@end
