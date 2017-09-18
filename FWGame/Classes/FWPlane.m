//
//  FWPlane.m
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWPlane.h"

#define FWPlaneSize (KScreenWidth/5)

@implementation FWPlane


+(instancetype)createEnemyPlane
{
    NSString * imageName = [SourceTool enemyImageNameByRandomWithGameLevel:GCxt.gameLevel];
    if (imageName) {
        if ([UIImage imageNamed:imageName]) {
            return [[FWPlane alloc] initWithImageNamed:imageName isMajorPlane:NO];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
    
}

-(instancetype)initWithImageNamed:(NSString *)name isMajorPlane:(BOOL)isMajorPlane
{
    if (self = [super initWithTexture:[SKTexture textureWithImageNamed:name]]) {
        
        self.size = CGSizeMake(FWPlaneSize, FWPlaneSize);
        
        SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        physicsBody.dynamic = YES;
        physicsBody.restitution = 1.0;
        physicsBody.charge = 0.5;
        physicsBody.mass = 1000;
        physicsBody.density = 1000;

        if (isMajorPlane) {
            physicsBody.allowsRotation = NO;
            physicsBody.linearDamping = 1.0;
            physicsBody.friction = 0.0;
            physicsBody.angularDamping = 0.8;
            physicsBody.fieldBitMask = GamePhyPlane_Enemy|GamePhyEdge;
            physicsBody.categoryBitMask = GamePhyPlane_Major;
            physicsBody.contactTestBitMask = GamePhyPlane_Enemy|GamePhyBullet_Enemy|GamePhyEdge;
            physicsBody.collisionBitMask = GamePhyEdge|GamePhyPlane_Enemy|GamePhyBullet_Major;
            self.name = @"myplane";
            
        }else{
            physicsBody.fieldBitMask = GamePhyBullet_Major;
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
            self.name = @"enemyplane";
            
            
            
        }
        
        
        self.physicsBody = physicsBody;
        
        self.zPosition = GameLayerSprite;
        
        self.planeLevel = 1;
        
    }
    
    return self;
}

-(void)setPlaneLevel:(NSUInteger)planeLevel
{
    _planeLevel = planeLevel;
    self.size = CGSizeMake(FWPlaneSize+10*(planeLevel-1), FWPlaneSize+10*(planeLevel-1));
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
            self.physicsBody = nil;
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
    
    SKAction * boomAction = [SKAction group:@[FWSB.boomSoundAction,
                      [SKAction animateWithTextures:boomTextures timePerFrame:0.07]
                                              ]];
    [self runAction:[SKAction sequence:@[
                                         boomAction,
                                         [SKAction removeFromParent]
                                         ]]];
    [GCxt addExp:10.0];
    GCxt.gameScore += 10;
}


-(NSTimeInterval)bulletRate
{
    switch (self.planeLevel) {
        case 1:
            return 0.3;
            break;
        case 2:
            return 0.2;
            break;
        case 3:
            return 0.1;
            break;
        default:
            return 0.1;
            break;
    }
}
-(void)fireBullet
{
    [self stopFireBullet];
    __weak typeof(self)weakSelf = self;
    SKAction * createBulletAction = [SKAction runBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        FWBullet * bullet = [FWBullet bulletWithParentPlane:strongSelf];
        
        bullet.position = CGPointMake(strongSelf.position.x, strongSelf.position.y + strongSelf.size.height/2 + 10);
        
        
        
        bullet.physicsBody.velocity = CGVectorMake(0, bullet.bulletSpeed);
        
        [strongSelf.parent addChild:bullet];
        
    }];
    
    
    SKAction * wait = [SKAction waitForDuration:self.bulletRate];
    
    [self.parent runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                              createBulletAction,
                                                                              wait
                                                                              ]]] withKey:@"fire_bullet"];
}

-(void)stopFireBullet
{
    [self.parent removeActionForKey:@"fire_bullet"];
}


-(void)enemyFlyDown
{
    
    self.physicsBody.velocity = CGVectorMake(0, -FWEnemyPlaneSpeed);
    self.physicsBody.charge = -0.2;
    
    
}


@end
