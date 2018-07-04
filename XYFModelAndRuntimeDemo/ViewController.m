//
//  ViewController.m
//  XYFModelAndRuntimeDemo
//
//  Created by Mac on 2018/7/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "UIControl+ClickBlock.h"
#import "Person.h"
#import "NSObject+XYFModel.h"
#import "Monkey.h"
#import "UIImage+image.h"
#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [UIImage imageNamed:@""];
    NSLog(@"%@", ((NSString *(*)(id, SEL, NSInteger)) objc_msgSend)([UIImage class], @selector(cvbnm:), 233333));
    
    NSObject *obj = [[NSObject alloc] init];
    obj.name = @"XYFCoder object";
    NSLog(@"%@", obj.name);
    
    const char *b = "testWithStr:integer:";
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.bounds];
    control.backgroundColor = [UIColor redColor];
    objc_setAssociatedObject(control, "xyf_tag", @"777", OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.view addSubview:control];
    NSDictionary *friendDic0 = @{@"name" : @"zhangsan", @"age" : @50, @"child" : @{@"name" : @"xiaohua", @"age" : @26, @"child" : @{@"name" : @"xiaotian", @"age" : @3, @"gender" : @"female"}}, @"gender" : @"male"};
    NSDictionary *friendDic1 = @{@"name" : @"lisi", @"age" : @47, @"child" : @{@"name" : @"liling", @"age" : @23, @"gender" : @"female"}};
    NSDictionary *friendDic2 = @{@"name" : @"wangwu", @"age" : @51, @"child" : @{@"name" : @"wanghua", @"age" : @26, @"child" : @{@"name" : @"xiaolin", @"age" : @2}}, @"gender" : @"male", @"phones" : @[@{@"phoneNum" : @"13898762344", @"color" : [UIColor orangeColor]}, @{@"phoneNum" : @"17732435436", @"color" : [UIColor redColor]}]};
    NSDictionary *dic = @{@"name" : @"Father", @"age" : @48, @"child" : @{@"name" : @"son", @"age" : @24, @"child" : @{@"name" : @"grandSon", @"age" : @1}}, @"gender" : @"male", @"friends" : @[friendDic0, friendDic1, friendDic2], @"school" : @"wuhuyizhong", @"phones" : @[@[@{@"phoneNum" : @"13198763222", @"color" : [UIColor blueColor]}, @{@"phoneNum" : @"18898873234", @"color" : [UIColor blackColor]}], @[@{@"phoneNum" : @"15538789000", @"color" : [UIColor purpleColor]}, @{@"phoneNum" : @"18745379421", @"color" : [UIColor orangeColor]}]], @"height" : @172.5, @"weight" : @"67"};
    // ToDo@"23.66"的情况
    Person *person = [Person modelWithDictionary:dic];
    //    [person performSelector:@selector(testLog) withObject:nil afterDelay:0.0f];
    ((void (*) (id, SEL, SEL, id, float)) objc_msgSend)(person, sel_registerName("performSelector:withObject:afterDelay:"), sel_registerName("testLog"), nil, 0.0f);
    ((void (*)(id, SEL, NSString *)) objc_msgSend)(person, @selector(eat:), @"ccvv777");
    //    Person *person = [[Person alloc] init];
    //    person.name = @"xiaoMing";
    //    person.age = @23;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.archiver"];
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    __weak typeof(self) weakSelf = self;
    control.click = ^(UIControl *ctl) {
        NSLog(@"%@---%@", ((NSString *(*)(id, SEL, NSString *, NSInteger)) objc_msgSend)(weakSelf, sel_registerName(b), @"xxxxx", 35), [ctl valueForKey:[NSString stringWithUTF8String:"xyf_tag"]]);
        Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        NSLog(@"%@", [p dictionaryFromModel]);
        ctl.backgroundColor = [p dictionaryFromModel][@"phones"][1][1][@"color"];
        //        unsigned int count = 0;
        //        Class *clses = objc_copyClassList(&count);
        //        for (unsigned int i = 0; i < count; i++) {
        //            Class cls = clses[i];
        //            const char *clsName = class_getName(cls);
        //            printf("%i---%s\n", i, clsName);
        //        }
    };
    
    Monkey *monkey = [[Monkey alloc] init];
    ((void (*)(id, SEL)) objc_msgSend)(monkey, sel_registerName("fly"));
}

- (NSString *)testWithStr:(NSString *)str integer:(NSInteger)integer {
    return [NSString stringWithFormat:@"%@%ld", str, (long)integer];
}

@end
