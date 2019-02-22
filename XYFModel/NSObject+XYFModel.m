//
//  NSObject+XYFModel.m
//  XYFModelAndRuntimeDemo
//
//  Created by Mac on 2018/7/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NSObject+XYFModel.h"
#import <objc/message.h>

@implementation NSObject (XYFModel)

+ (NSArray *)handleArrayValueWithValue:(NSArray *)value ivarName:(NSString *)ivarName {
    NSMutableArray *temArr = @[].mutableCopy;
    for (id object in value) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([[self class] respondsToSelector:sel_registerName("modelClassInArray")]) {
                NSDictionary *modelClassMapperDic = ((NSDictionary *(*)(id, SEL)) objc_msgSend)([self class], sel_registerName("modelClassInArray"));
                Class modelClass = modelClassMapperDic[ivarName];
                if (modelClass) {
                    [temArr addObject:[modelClass modelWithDictionary:object]];
                } else {
                    [temArr addObject:object];
                }
            } else {
                [temArr addObject:object];
            }
        } else {
            if ([object isKindOfClass:[NSArray class]]) {
                [temArr addObject:[self handleArrayValueWithValue:object ivarName:ivarName]];
            } else {
                [temArr addObject:object];
            }
        }
    }
    return temArr.copy;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)aDictionary {
    if ([NSBundle bundleForClass:[self class]] != [NSBundle mainBundle]) {
        NSLog(@"XYFModel warm hint: you are using non-custom class.");
    }
    NSObject *obj = [[self alloc] init];
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar var = vars[i];
        NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *ivarType = [[[NSString stringWithUTF8String:ivar_getTypeEncoding(var)] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        NSString *dicKey = ivarName;
        if ([[self class] respondsToSelector:sel_registerName("dictionaryKeyMappingModelKey")]) {
            id keyMapper = ((NSDictionary *(*)(id, SEL)) objc_msgSend)([self class], sel_registerName("dictionaryKeyMappingModelKey"));
            if ([keyMapper isKindOfClass:[NSDictionary class]]) {
                for (NSString *key in [keyMapper allKeys]) {
                    if ([keyMapper[key] isEqualToString:ivarName]) {
                        dicKey = key;
                    }
                }
            }
        }
        
        id value = aDictionary[dicKey];
        Class cls = NSClassFromString(ivarType);
        if ([value isKindOfClass:[NSArray class]]) {
            value = [self handleArrayValueWithValue:value ivarName:ivarName];
        }
        if ([value isKindOfClass:[NSDictionary class]] && [NSBundle bundleForClass:cls] == [NSBundle mainBundle]) {
            value = [cls modelWithDictionary:value];
        }
        if (value) {
            if (!cls) { // 模型属性为基本类型
                NSString *methodName = [NSString stringWithFormat:@"set%@%@:", [ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                SEL setterSel = sel_registerName(methodName.UTF8String);
                if ([obj respondsToSelector:setterSel]) {
                    if ([value isKindOfClass:[NSString class]]) {
                        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                        if ([value containsString:@"."]) {
                            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                        } else {
                            [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
                        }
                        value = [numberFormatter numberFromString:value];
                    }
                    if ([ivarType isEqualToString:@"i"]) {
                        int vle = [value intValue];
                        ((void (*)(id, SEL, int)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"f"]) {
                        float vle = [value floatValue];
                        ((void (*)(id, SEL, float)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"d"]) {
                        double vle = [value doubleValue];
                        ((void (*)(id, SEL, double)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"B"]) {
                        BOOL vle = [value boolValue];
                        ((void (*)(id, SEL, BOOL)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"l"]) {
                        long vle = [value longValue];
                        ((void (*)(id, SEL, long)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"I"]) {
                        unsigned int vle = [value unsignedIntValue];
                        ((void (*)(id, SEL, unsigned int)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"q"]) {
                        NSInteger vle = [value integerValue];
                        ((void (*)(id, SEL, NSInteger)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"s"]) {
                        short vle = [value shortValue];
                        ((void (*)(id, SEL, short)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"S"]) {
                        unsigned short vle = [value unsignedShortValue];
                        ((void (*)(id, SEL, unsigned short)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"L"]) {
                        unsigned long vle = [value unsignedLongValue];
                        ((void (*)(id, SEL, unsigned long)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"Q"]) {
                        NSUInteger vle = [value unsignedIntegerValue];
                        ((void (*)(id, SEL, NSUInteger)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"c"]) {
                        char vle = [value charValue];
                        ((void (*)(id, SEL, char)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"C"]) {
                        unsigned char vle = [value unsignedCharValue];
                        ((void (*)(id, SEL, unsigned char)) objc_msgSend)(obj, setterSel, vle);
                    } else if ([ivarType containsString:@"NSRange"]) {
                        NSRange vle = [value rangeValue];
                        ((void (*)(id, SEL, NSRange)) objc_msgSend)(obj, setterSel, vle);
                    }
                }
            } else { // 模型属性为对象类型
                [obj setValue:value forKey:ivarName];
            }
        }
    }
    free(vars);
    return obj;
}

- (NSDictionary *)dictionaryFromModel {
    return [self dictionaryFromModelHasZeroValue:YES];
}

- (NSArray *)handleModelArrayWithValue:(NSArray *)value flag:(BOOL)flag {
    NSMutableArray *temArr = @[].mutableCopy;
    for (id object in value) {
        if ([NSBundle bundleForClass:[object class]] == [NSBundle mainBundle]) {
            [temArr addObject:[object dictionaryFromModelHasZeroValue:flag]];
        } else {
            if ([object isKindOfClass:[NSArray class]]) {
                [temArr addObject:[self handleModelArrayWithValue:object flag:flag]];
            } else {
                [temArr addObject:object];
            }
        }
    }
    return temArr.copy;
}

- (NSDictionary *)dictionaryFromModelHasZeroValue:(BOOL)flag {
    NSMutableDictionary *dic = @{}.mutableCopy;
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    for (NSInteger i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *attributes = property_getAttributes(property);
        NSArray *typesArray = [[NSString stringWithUTF8String:attributes] componentsSeparatedByString:@","];
        NSString *firstType = typesArray.firstObject;
        firstType = [[[[firstType stringByReplacingOccurrencesOfString:@"T" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        Class propertyClass = NSClassFromString(firstType);
        const char *propertyName = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        SEL method = sel_registerName(propertyName);
        if ([self respondsToSelector:method]) {
            if (!propertyClass) { // 模型属性为基本类型
                if ([firstType isEqualToString:@"i"]) {
                    int vle = ((int (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"f"]) {
                    float vle = ((float (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"d"]) {
                    double vle = ((double (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"B"]) {
                    BOOL vle = ((BOOL (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"l"]) {
                    long vle = ((long (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"I"]) {
                    unsigned int vle = ((unsigned int (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"q"]) {
                    NSInteger vle = ((NSInteger (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"s"]) {
                    short vle = ((short (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"S"]) {
                    unsigned short vle = ((unsigned short (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"L"]) {
                    unsigned long vle = ((unsigned long (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"Q"]) {
                    NSUInteger vle = ((NSUInteger (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"c"]) {
                    char vle = ((char (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType isEqualToString:@"C"]) {
                    unsigned char vle = ((unsigned char (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle) {
                        dic[key] = @(vle);
                    }
                } else if ([firstType containsString:@"NSRange"]) {
                    NSRange vle = ((NSRange (*)(id, SEL)) objc_msgSend)(self, method);
                    if (flag || vle.location != 0 || vle.length != 0) {
                        dic[key] = [NSValue valueWithRange:vle];
                    }
                }
            } else { // 模型属性为对象类型
                id value = ((id (*)(id, SEL)) objc_msgSend)(self, method);
                // [NSBundle bundleForClass:propertyClass] == [NSBundle mainBundle]表示是自定义的类，否则是系统的类
                if ([value isKindOfClass:[NSArray class]]) {
                    value = [self handleModelArrayWithValue:value flag:flag];
                }
                if ([NSBundle bundleForClass:propertyClass] == [NSBundle mainBundle] && value) {
                    value = [value dictionaryFromModelHasZeroValue:flag];
                }
                if (value) {
                    dic[key] = value;
                }
            }
        }
    }
    free(propertyList);
    return dic.copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    Ivar *vars = class_copyIvarList([self class], &outCount);
    for (NSInteger i = 0; i < outCount; i++) {
        Ivar var = vars[i];
        NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *ivarType = [[[NSString stringWithUTF8String:ivar_getTypeEncoding(var)] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""];
        Class cls = NSClassFromString(ivarType);
        if (cls) { // 对象类型
            id value = [self valueForKey:ivarName];
            [aCoder encodeObject:value forKey:ivarName];
        } else { // 基本类型
            SEL getterSel = sel_registerName(ivarName.UTF8String);
            if ([self respondsToSelector:getterSel]) {
                if ([ivarType isEqualToString:@"i"]) {
                    int vle = ((int (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"f"]) {
                    float vle = ((float (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeFloat:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"d"]) {
                    double vle = ((double (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeDouble:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"B"]) {
                    BOOL vle = ((BOOL (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeBool:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"l"]) {
                    long vle = ((long (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt64:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"I"]) {
                    unsigned int vle = ((unsigned int (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"q"]) {
                    NSInteger vle = ((NSInteger (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInteger:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"s"]) {
                    short vle = ((short (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"S"]) {
                    unsigned short vle = ((unsigned short (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"L"]) {
                    unsigned long vle = ((unsigned long (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt64:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"Q"]) {
                    NSUInteger vle = ((NSUInteger (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt64:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"c"]) {
                    char vle = ((char (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType isEqualToString:@"C"]) {
                    unsigned char vle = ((unsigned char (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeInt:vle forKey:ivarName];
                } else if ([ivarType containsString:@"NSRange"]) {
                    NSRange vle = ((NSRange (*)(id, SEL)) objc_msgSend)(self, getterSel);
                    [aCoder encodeObject:[NSValue valueWithRange:vle] forKey:ivarName];
                }
            }
        }
    }
    free(vars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        unsigned int outCount = 0;
        Ivar *vars = class_copyIvarList([self class], &outCount);
        for (NSInteger i = 0; i < outCount; i++) {
            Ivar var = vars[i];
            NSString *ivarName = [[NSString stringWithUTF8String:ivar_getName(var)] stringByReplacingOccurrencesOfString:@"_" withString:@""];
            NSString *ivarType = [[[NSString stringWithUTF8String:ivar_getTypeEncoding(var)] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            Class cls = NSClassFromString(ivarType);
            if (cls) { // 对象类型
                id value = [aDecoder decodeObjectForKey:ivarName];
                [self setValue:value forKey:ivarName];
            } else { // 基本类型
                NSString *methodName = [NSString stringWithFormat:@"set%@%@:", [ivarName substringToIndex:1].uppercaseString, [ivarName substringFromIndex:1]];
                SEL setterSel = sel_registerName(methodName.UTF8String);
                if ([self respondsToSelector:setterSel]) {
                    if ([ivarType isEqualToString:@"i"]) {
                        int vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, int)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"f"]) {
                        float vle = [aDecoder decodeFloatForKey:ivarName];
                        ((void (*)(id, SEL, float)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"d"]) {
                        double vle = [aDecoder decodeDoubleForKey:ivarName];
                        ((void (*)(id, SEL, double)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"B"]) {
                        BOOL vle = [aDecoder decodeBoolForKey:ivarName];
                        ((void (*)(id, SEL, BOOL)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"l"]) {
                        long vle = (long)[aDecoder decodeInt64ForKey:ivarName];
                        ((void (*)(id, SEL, long)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"I"]) {
                        unsigned int vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, unsigned int)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"q"]) {
                        NSInteger vle = [aDecoder decodeIntegerForKey:ivarName];
                        ((void (*)(id, SEL, NSInteger)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"s"]) {
                        short vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, short)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"S"]) {
                        unsigned short vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, unsigned short)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"L"]) {
                        unsigned long vle = (unsigned long)[aDecoder decodeInt64ForKey:ivarName];
                        ((void (*)(id, SEL, unsigned long)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"Q"]) {
                        NSUInteger vle = (NSUInteger)[aDecoder decodeInt64ForKey:ivarName];
                        ((void (*)(id, SEL, NSUInteger)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"c"]) {
                        char vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, char)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType isEqualToString:@"C"]) {
                        unsigned char vle = [aDecoder decodeIntForKey:ivarName];
                        ((void (*)(id, SEL, unsigned char)) objc_msgSend)(self, setterSel, vle);
                    } else if ([ivarType containsString:@"NSRange"]) {
                        NSRange vle = [[aDecoder decodeObjectForKey:ivarName] rangeValue];
                        ((void (*)(id, SEL, NSRange)) objc_msgSend)(self, setterSel, vle);
                    }
                }
            }
        }
        free(vars);
    }
    return self;
}

@end
