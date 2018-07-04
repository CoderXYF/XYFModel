//
//  Person.h
//  Runtime运用
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Phone;

@interface Person : NSObject

@property (nonatomic, assign) NSRange range;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *age;

@property (nonatomic, strong) Person *child;

@property (nonatomic, copy) NSArray<Person *> *friends;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *hobby;

@property (nonatomic, copy) NSArray<Phone *> *phones;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) short weight;

@end
