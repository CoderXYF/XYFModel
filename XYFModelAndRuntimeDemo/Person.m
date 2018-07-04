//
//  Person.m
//  Runtime运用
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>
#import "Phone.h"

@implementation Person

+ (NSDictionary *)modelClassInArray {
    return @{@"phones" : [Phone class],
             @"friends" : [Person class]
             };
}

void run(id xxx, SEL yyy, NSString *string) {
//    NSLog(@"--->%@", string);
    NSLog(@"%@, %@, %@", xxx, NSStringFromSelector(yyy), string);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == sel_registerName("eat:")) {
        class_addMethod(self, sel, (IMP)run, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (void)initialize {
    
}

- (void)testLog {
    NSLog(@"testLog..");
}

@end
