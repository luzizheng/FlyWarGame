//
//  FWProgressNode.m
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWProgressNode.h"

@interface FWProgressNode()

@property(nonatomic,strong)SKSpriteNode * frontNode;
@property(nonatomic,strong)SKShapeNode * bgNode;
@property(nonatomic,assign,readwrite)CGSize size;
@property(nonatomic,strong)UIColor * strokeColor;
@property(nonatomic,strong)UIColor * fillColor;
@end

@implementation FWProgressNode
-(instancetype)initWithRectOfSize:(CGSize)size
                   andStrokeColor:(UIColor *)strokeColor
                     andFillColor:(UIColor *)fillColor
{
    
    if (self = [super init]) {
        
        self.strokeColor = strokeColor;
        self.fillColor = fillColor;
        self.size = size;
        [self addChild:self.bgNode];
        [self addChild:self.frontNode];
        
    }
    return self;
    
}


-(SKShapeNode *)bgNode
{
    if (!_bgNode) {
        _bgNode = [SKShapeNode shapeNodeWithRectOfSize:self.size cornerRadius:0];
        
        _bgNode.strokeColor = self.strokeColor;
        _bgNode.glowWidth = 2.0;
        _bgNode.fillColor = [UIColor clearColor];
        
    }
    return _bgNode;
}

-(SKSpriteNode *)frontNode
{
    if (!_frontNode) {
        _frontNode = [SKSpriteNode spriteNodeWithColor:self.fillColor size:self.size];
    }
    return _frontNode;
}


-(void)setProgress:(CGFloat)progress
{
    if (progress<=0.0000) {
        _progress = 0.0000;
    }else if (progress>=1.0000){
        _progress = 1.0000;
    }else{
        _progress = progress;
    }
    
    CGFloat width = self.size.width * _progress;
    
    CGFloat x = width/2 - self.size.width/2;
    
    self.frontNode.size = CGSizeMake(width, self.frontNode.size.height);
    self.frontNode.position = CGPointMake(x, self.frontNode.position.y);
    
    
}



@end
