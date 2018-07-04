//
//  NSObject+XYFModel.h
//  XYFModelAndRuntimeDemo
//
//  Created by Mac on 2018/7/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XYFModel)

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
