//
//  UIControl+ClickBlock.h
//  Runtime运用
//
//  Created by Mac on 2018/6/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(UIControl *ctl);

@interface UIControl (ClickBlock)

@property (nonatomic, copy) ClickBlock click;

@end
