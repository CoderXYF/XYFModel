//
//  UIImage+image.m
//  Runtime运用
//
//  Created by Mac on 2018/6/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UIImage+image.h"
#import <objc/message.h>
#import "Monkey.h"

@implementation UIImage (image)

//- (void)test {
//    
//}

NSString *(myImplementationFunction)(id xxx, SEL yyy, NSInteger num) {
    NSLog(@"%@, %@, %zd", xxx, NSStringFromSelector(yyy), num);
    return [NSString stringWithFormat:@"%@~~%@~~%zd", xxx, NSStringFromSelector(yyy), num];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
//    return NO;
    if (sel == @selector(cvbnm:)) {
        class_addMethod(objc_getMetaClass(NSStringFromClass([self class]).UTF8String), sel, (IMP)myImplementationFunction, "@@:L");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
//    return nil;
    if (aSelector == sel_registerName("cvbnm:")) {
        return [Monkey class];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(cvbnm:)) {
        return [NSMethodSignature signatureWithObjCTypes:"@@:L"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([Monkey respondsToSelector:@selector(cvbnm:)]) {
        [anInvocation invokeWithTarget:[Monkey class]];
    } else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
}

//+ (void)load {
//    Method imageNamed = class_getClassMethod(self, @selector(imageNamed:));
//    Method imageWithName = class_getClassMethod(self, @selector(imageWithName:));
//    method_exchangeImplementations(imageNamed, imageWithName);
//}
//
//+ (instancetype)imageWithName:(NSString *)imageName {
//    UIImage *image = [self imageWithName:imageName];
//    if (!image) {
//        NSLog(@"Loading null image！");
//    }
//    return image;
//}

@end
