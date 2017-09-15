//
//  FWProgressNode.h
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface FWProgressNode : SKNode


-(instancetype)initWithRectOfSize:(CGSize)size
                   andStrokeColor:(UIColor *)strokeColor
                     andFillColor:(UIColor *)fillColor;

@property(nonatomic,assign,readonly)CGSize size;
@property(nonatomic,assign)CGFloat progress;


@end
