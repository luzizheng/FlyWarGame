//
//  FWPlane.m
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWPlane.h"

@implementation FWPlane
-(instancetype)initWithImageNamed:(NSString *)name isMajorPlane:(BOOL)isMajorPlane
{
    if (self = [super initWithImageNamed:name]) {
        
        self.size = CGSizeMake(KScreenWidth/5, KScreenWidth/5);
        
        SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        physicsBody.dynamic = YES;
        physicsBody.restitution = 1.0;
        physicsBody.charge = 0.5;
        physicsBody.mass = 1000;
        physicsBody.density = 1000;
        if (isMajorPlane) {
            physicsBody.categoryBitMask = GamePhyPlane_Major;
            physicsBody.contactTestBitMask = GamePhyPlane_Enemy|GamePhyBullet_Enemy;
            physicsBody.collisionBitMask = 0;
        }else{
            physicsBody.categoryBitMask = GamePhyPlane_Enemy;
            physicsBody.contactTestBitMask = GamePhyPlane_Major|GamePhyBullet_Major;
            physicsBody.collisionBitMask = GamePhyBullet_Major|GamePhyPlane_Major;
            
            SKShapeNode * hpLine = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.size.width, 3)];
            [self drawPathRefWithNode:hpLine andValue:FWPlaneHP_Enemy];
            hpLine.fillColor = [UIColor redColor];
            hpLine.position =CGPointMake(0, self.size.height);
            hpLine.name = @"hp";
            hpLine.alpha = 0.8;
            [self addChild:hpLine];
            
        }
        
        
        self.physicsBody = physicsBody;
        self.name = @"plane";
        self.zPosition = GameLayerSprite;
        
        self.planeLevel = 1;
        
    }
    
    return self;
}

-(void)drawPathRefWithNode:(SKShapeNode *)shapeNode andValue:(NSInteger)value
{
    shapeNode.path = nil;
    CGFloat height = 3.0;
    CGFloat width = self.size.width;
    CGFloat length = (((double)value)/((double)FWPlaneHP_Enemy))*width;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, nil, -width/2, 0);//起点
    CGPathAddLineToPoint(pathRef, nil, length-width/2, 0);
    CGPathAddLineToPoint(pathRef, nil, length-width/2, height);
    CGPathAddLineToPoint(pathRef, nil, -width/2, height);
    CGPathCloseSubpath(pathRef);
    shapeNode.path = pathRef;
    CGPathRelease(pathRef);// 释放
}

-(void)hitByAttack:(NSInteger)attackValue
{
    if (attackValue > self.HP) {
        self.HP = 0;
    }else{
        self.HP = self.HP - attackValue;
    }
}

-(void)setHP:(NSInteger)HP
{
    if (HP>0) {
        _HP = HP;
    }else{
        
        if (_HP>0) {
            [self boom];
        }
        _HP = 0;
    }
    SKShapeNode * hpLine = (SKShapeNode *)[self childNodeWithName:@"hp"];
    if (hpLine) {
        [self drawPathRefWithNode:hpLine andValue:_HP];
    }
    
}

-(void)boom
{
    
    NSMutableArray * boomTextures = [NSMutableArray array];
    for (int i = 1; i<10; i++) {
        SKTexture * t = [SKTexture textureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"boom_0%d",i]]];
        [boomTextures addObject:t];
    }
    
    SKAction * boomAction = [SKAction group:@[[SKAction playSoundFileNamed:@"boom.mp3" waitForCompletion:NO],
                      [SKAction animateWithTextures:boomTextures timePerFrame:0.07]
                                              ]];
    [self runAction:[SKAction sequence:@[
                                         boomAction,
                                         [SKAction removeFromParent]
                                         ]]];
    GCxt.score += 10;
}


-(FWBullet *)myBullet
{
    return [FWBullet bulletWithParentPlane:self];
}
@end
