//
//  UIColor+Utils.m
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)
+(NSArray *)colorArrayByStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor andArrayCount:(NSInteger)arrayCount
{
    if (startColor&&endColor&&arrayCount>0) {
        CGFloat r_start;
        CGFloat g_start;
        CGFloat b_start;
        CGFloat r_end;
        CGFloat g_end;
        CGFloat b_end;
        if ([startColor getRed:&r_start green:&g_start blue:&b_start alpha:NULL] && [endColor getRed:&r_end green:&g_end blue:&b_end alpha:NULL]) {
            NSMutableArray * tmp = [NSMutableArray array];
            for (int i =1 ; i<=arrayCount; i++) {
                CGFloat r_k = MAX(0, r_start + (r_end-r_start) * (CGFloat)i);
                CGFloat g_k = MAX(0, g_start + (g_end-g_start) * (CGFloat)i);
                CGFloat b_k = MAX(0, b_start + (b_end-b_start) * (CGFloat)i);
                [tmp addObject:[UIColor colorWithRed:r_k green:g_k blue:b_k alpha:1.0]];
            }
            return tmp;
        }else{
            return [NSArray array];
        }
    }else{
        return [NSArray array];
    }
    
}
@end
