# XYFModel
iOS, Objective-C, 字典转模型, 模型转字典, 模型归档接档, 安全、轻量、使用简单 Dictionary to model, model to dictionary, archive model to file and unarchive model from file, Simple, safety and light weight.
  
  Usage
==============

### Model dictionry convert
```objc
// dictionry:
NSDictionary *friendDic0 = @{@"name" : @"zhangsan", @"age" : @50, @"child" :   
@{@"name" : @"xiaohua", @"age" : @26, @"child" :   
@{@"name" : @"xiaotian", @"age" : @3, @"gender" : @"female"}}, @"gender" : @"male"};
NSDictionary *friendDic1 = @{@"name" : @"lisi", @"age" : @47, @"child" :   
@{@"name" : @"liling", @"age" : @23, @"gender" : @"female"}};
NSDictionary *friendDic2 = @{@"name" : @"wangwu", @"age" : @51, @"child" :   
@{@"name" : @"wanghua", @"age" : @26, @"child" :   
@{@"name" : @"xiaolin", @"age" : @2}}, @"gender" : @"male", @"phones" :   
@[@{@"phoneNum" : @"13898762344", @"color" : [UIColor orangeColor]},   
@{@"phoneNum" : @"17732435436", @"color" : [UIColor redColor]}]};
NSDictionary *dic = @{@"name" : @"Father", @"age" : @48, @"child" :   
@{@"name" : @"son", @"age" : @24, @"child" : @{@"name" : @"grandSon", @"age" : @1}},   
@"gender" : @"male", @"friends" : @[friendDic0, friendDic1, friendDic2],   
@"school" : @"wuhuyizhong", @"phones" : @[@[@{@"phoneNum" : @"13198763222",   
@"color" : [UIColor blueColor]}, @{@"phoneNum" : @"18898873234",   
@"color" : [UIColor blackColor]}], @[@{@"phoneNum" : @"15538789000",   
@"color" : [UIColor purpleColor]}, @{@"phoneNum" : @"18745379421",   
@"color" : [UIColor orangeColor]}]], @"height" : @172.5, @"weight" : @"67"};

// Model:
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

#import "Person.h"
#import <objc/message.h>
#import "Phone.h"
@implementation Person
+ (NSDictionary *)modelClassInArray {
    return @{@"phones" : [Phone class],
             @"friends" : [Person class]
             };
}
@end  

// Convert json(dictionary) to model:
Person *person = [Person modelWithDictionary:dic];
// Archive model to path
NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.archiver"];  
[NSKeyedArchiver archiveRootObject:person toFile:path];
// Unarchive model from path  
Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
// Convert model to json(dictionary):
NSDictionary *json = [p dictionaryFromModel];
```

Installation
==============

### CocoaPods

1. Add `pod 'XYFModel'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<NSObject+XYFModel.h\>.

### Manually

1. Download XYFModelAndRuntimeDemo and find XYFModel finder.
2. Add the source files to your Xcode project.
3. Import `NSObject+XYFModel.h`.

Requirements
==============
This library requires `iOS 8.0+`.

License
==============
XYFModel is provided under the MIT license. See LICENSE file for details.  

<br/><br/>
---
中文介绍
==============
安全、轻量、使用简单的 iOS/OSX 模型转换框架。<br/>

使用方法
==============

### 简单的 Model 与 JSON 相互转换
```objc
// dictionry:
NSDictionary *friendDic0 = @{@"name" : @"zhangsan", @"age" : @50, @"child" :   
@{@"name" : @"xiaohua", @"age" : @26, @"child" :   
@{@"name" : @"xiaotian", @"age" : @3, @"gender" : @"female"}}, @"gender" : @"male"};
NSDictionary *friendDic1 = @{@"name" : @"lisi", @"age" : @47, @"child" :   
@{@"name" : @"liling", @"age" : @23, @"gender" : @"female"}};
NSDictionary *friendDic2 = @{@"name" : @"wangwu", @"age" : @51, @"child" :   
@{@"name" : @"wanghua", @"age" : @26, @"child" :   
@{@"name" : @"xiaolin", @"age" : @2}}, @"gender" : @"male", @"phones" :   
@[@{@"phoneNum" : @"13898762344", @"color" : [UIColor orangeColor]},   
@{@"phoneNum" : @"17732435436", @"color" : [UIColor redColor]}]};
NSDictionary *dic = @{@"name" : @"Father", @"age" : @48, @"child" :   
@{@"name" : @"son", @"age" : @24, @"child" : @{@"name" : @"grandSon", @"age" : @1}},   
@"gender" : @"male", @"friends" : @[friendDic0, friendDic1, friendDic2],   
@"school" : @"wuhuyizhong", @"phones" : @[@[@{@"phoneNum" : @"13198763222",   
@"color" : [UIColor blueColor]}, @{@"phoneNum" : @"18898873234",   
@"color" : [UIColor blackColor]}], @[@{@"phoneNum" : @"15538789000",   
@"color" : [UIColor purpleColor]}, @{@"phoneNum" : @"18745379421",   
@"color" : [UIColor orangeColor]}]], @"height" : @172.5, @"weight" : @"67"};

// Model:
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

#import "Person.h"
#import <objc/message.h>
#import "Phone.h"
@implementation Person
+ (NSDictionary *)modelClassInArray {
    return @{@"phones" : [Phone class],
             @"friends" : [Person class]
             };
}
@end  

// Convert json(dictionary) to model:
Person *person = [Person modelWithDictionary:dic];
// Archive model to path
NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"person.archiver"];  
[NSKeyedArchiver archiveRootObject:person toFile:path];
// Unarchive model from path  
Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
// Convert model to json(dictionary):
NSDictionary *json = [p dictionaryFromModel];
```

安装
==============

### CocoaPods

1. 在 Podfile 中添加 `pod 'XYFModel'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<NSObject+XYFModel.h\>。

### 手动安装

1. 下载 XYFModelAndRuntimeDemo 并找到 XYFModel 文件夹。
2. 将 XYFModel 内的源文件添加(拖放)到你的工程。
3. 导入 `NSObject+XYFModel.h`。

系统要求
==============
该工具最低支持 `iOS 8.0`。

许可证
==============
XYFModel 使用 MIT 许可证，详情见 LICENSE 文件。  

联系作者和学习交流
==============
有任何疑问或者想要探讨关于xyf_model字典模型相互转换以及归档接档或者runtime相关知识等可以加qq群790756256,我们一起探讨交流相互学习!


