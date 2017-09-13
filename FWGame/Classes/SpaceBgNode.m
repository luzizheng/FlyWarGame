//
//  SpaceBgNode.m
//  FWGame
//
//  Created by Luzz on 2017/9/12.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "SpaceBgNode.h"

@implementation SpaceBgNode
{
    CGSize _gsSize;
    CGSize _bgSize;
    CGFloat _repeatH;
}

- (instancetype)initWithGameSceneSize:(CGSize)gsSize
{
    self = [super init];
    if (self) {
        _gsSize = gsSize;
        [self setupChildrenNodes];
    }
    return self;
}

-(void)setupChildrenNodes
{
    NSString * imgName = @"space";
    CGSize imgSize = [UIImage imageNamed:imgName].size;
    CGFloat imageW = imgSize.width;
    CGFloat imageH = imgSize.height;
    
    CGFloat w_forCount = 0;
    CGFloat h_forCount = 0;
    
    
    
    int row = resultOfNum(_gsSize.width, imageW);
    int line = resultOfNum(_gsSize.height, imageH);
    
    _repeatH = line * imageH;
    
    for (int i =0; i<row; i++) {
        
        
        w_forCount += imageW;
        
        for (int j = 0; j<line*2; j++) {
            
            h_forCount += imageH;
            
            SKSpriteNode * node = [SKSpriteNode spriteNodeWithImageNamed:imgName];
            node.anchorPoint = CGPointZero;
            node.position = CGPointMake(i*imageW, j*imageH);
            [self addChild:node];
            node.alpha = 0.4;

            
        }
    } 
    
    _bgSize = CGSizeMake(w_forCount, h_forCount);
    
}
-(CGSize)spaceBgSize
{
    return _bgSize;
}

-(CGFloat)repeatHeight
{
    return _repeatH;
}

int resultOfNum(CGFloat a,CGFloat b)
{
    NSDecimalNumber * numberA = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",a]];
    NSDecimalNumber * numberB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",b]];
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [numberA decimalNumberByDividingBy:numberB withBehavior:handler].intValue;
}


@end
