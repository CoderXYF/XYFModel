//
//  NSObject+XYFModel.h
//  XYFModelAndRuntimeDemo
//
//  Created by Mac on 2018/7/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XYFModel)

/********* 使用指南 **********/
/*
1.对于字典中出现例如关键字id这种的字符串key，或者因为其他情况，模型中不能直接使用某个或者某几个字典的key作为对应模型的属性名称，这时候可以通过实现+ (NSDictionary *)modelClassInArray来解决，让模型使用跟字典key不一样名称的属性来接收该key对应的value值，例如：
 + (NSDictionary *)dictionaryKeyMappingModelKey {
     return @{@"id" : @"personId"};
 }
 
2.如果模型的一个属性是装着其他模型的数组（对应Json字典中的装着字典对象的数组value值）,那么可以在这个模型中实现+ (NSDictionary *)modelClassInArray方法来将其转为盛放对应模型的数组，并以此类推，例如：
 + (NSDictionary *)modelClassInArray {
      return @{@"phones" : [Phone class],
      @"friends" : [Person class]
      };
 }
 
Github：https://github.com/CoderXYF
作者：CoderXYF
QQ：2016003298
微信：yz33915958
ps：欢迎跟作者一起学习交流。

*/

/********* 这是分隔线 **********/

/**
 字典转模型
 
 @param aDictionary 传入的字典
 @return 返回模型
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)aDictionary;

/**
 模型转字典
 
 @return 返回字典
 */
- (NSDictionary *)dictionaryFromModel;

/**
 模型转字典
 
 @param flag 是否包含值为0的键值对（非对象类型）例如：price = 0;range = NSMakeRange(0, 0);
 @return 返回字典
 */
- (NSDictionary *)dictionaryFromModelHasZeroValue:(BOOL)flag;

@end
