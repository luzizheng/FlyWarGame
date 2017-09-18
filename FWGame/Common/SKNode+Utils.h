//
//  SKNode+Utils.h
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Utils)
-(void)shakeWithTimes:(NSInteger)times;


-(void)dropOutInfo:(NSString *)text andColor:(UIColor *)color andFontSize:(CGFloat)fontSize;

@end
