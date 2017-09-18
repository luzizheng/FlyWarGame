//
//  UIColor+Utils.h
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

/**
 线性色值
 
 @param startColor 起始颜色
 @param endColor 结尾颜色
 @param gradientLevel 取色级别 (0.0 - 1.0)
 @return 颜色
 */
+(UIColor *)getColorByGradientStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor andGradientLevel:(CGFloat)gradientLevel;

@end
