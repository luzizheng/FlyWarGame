//
//  FWBullet.m
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWBullet.h"
#import "FWPlane.h"
#import "UIColor+Utils.h"


@interface FWBullet()

@property(nonatomic,readwrite)NSInteger attack;
@property(nonatomic,readwrite)CGFloat bulletSpeed;
@end

@implementation FWBullet
+(instancetype)bulletWithParentPlane:(__kindof SKSpriteNode *)plane;
{
    CGFloat bullet_w = plane.size.width/5;
    
    

    
    UIColor * defaultColor = [UIColor cyanColor];
    UIColor * maxColor = [UIColor redColor];
    
    NSInteger level = ((FWPlane *)plane).planeLevel;
    
    UIColor * color = [UIColor getColorByGradientStartColor:defaultColor andEndColor:maxColor andGradientLevel:(CGFloat)level/5.0];

    
    NSInteger attack = 50 + (level-1)*20;
    CGFloat speed = FWBulletFlySpeed + (level-1);

    

    FWBullet * bullet = [[FWBullet alloc] initWithImageNamed:@"ball" andAttack:attack andSpeed:speed];
    
    bullet.size = CGSizeMake(bullet_w, bullet_w);
    bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:5];
    bullet.physicsBody.dynamic = YES;
    bullet.physicsBody.allowsRotation = NO;
    bullet.physicsBody.fieldBitMask = GamePhyPlane_Enemy;
    bullet.physicsBody.categoryBitMask = GamePhyBullet_Major;
    bullet.physicsBody.contactTestBitMask = GamePhyPlane_Enemy|GamePhyPlane_Major;
    bullet.physicsBody.collisionBitMask = GamePhyPlane_Enemy|GamePhyPlane_Major;
    bullet.physicsBody.charge = -100;
    bullet.physicsBody.mass = 1000;
    bullet.physicsBody.density = 1000;
    bullet.physicsBody.linearDamping = 0.5;
    
    SKEmitterNode * ballTrail = [SKEmitterNode nodeWithFileNamed:@"BallTrail2.sks"];
    ballTrail.particleSize = CGSizeMake(bullet_w*3, bullet_w*3);
    ballTrail.particleColor = color;
    
    ballTrail.position = CGPointMake(0, 0);
    ballTrail.targetNode = plane.parent;
    
    [bullet addChild:ballTrail];
    
    return bullet;
}


-(instancetype)initWithImageNamed:(NSString *)name andAttack:(NSInteger)attack andSpeed:(CGFloat)speed
{
    if (self = [super initWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:name]]]) {
        self.name = @"bullet";
        self.attack = attack;
        self.bulletSpeed = speed;
    }
    return self;
}




@end
