//
//  UIColor+Utils.m
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)
+(UIColor *)getColorByGradientStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor andGradientLevel:(CGFloat)gradientLevel
{
    
    if (startColor&&endColor) {
        
        
        if (gradientLevel<=0.0) {
            return startColor;
        }else if (gradientLevel>=1.0){
            return endColor;
        }else{
            CGFloat r_start;
            CGFloat g_start;
            CGFloat b_start;
            CGFloat r_end;
            CGFloat g_end;
            CGFloat b_end;
            if ([startColor getRed:&r_start green:&g_start blue:&b_start alpha:NULL] && [endColor getRed:&r_end green:&g_end blue:&b_end alpha:NULL]) {
                
                
                CGFloat r_k = MAX(0, r_start + (r_end-r_start) * gradientLevel);
                CGFloat g_k = MAX(0, g_start + (g_end-g_start) * gradientLevel);
                CGFloat b_k = MAX(0, b_start + (b_end-b_start) * gradientLevel);
                
                
                
                return [UIColor colorWithRed:MIN(1.0, r_k) green:MIN(1.0, g_k) blue:MIN(1.0, b_k) alpha:1.0];
            }else{
                return [UIColor clearColor];
            }
            
            
        }
        
    }else{
        return startColor;
    }
    
    
}
@end
