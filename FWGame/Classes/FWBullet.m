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
    NSInteger attack = 0;
    CGFloat speed = 0;
    

    
    UIColor * defaultColor = [UIColor colorWithRed:0.99 green:0.64 blue:0.18 alpha:1.0];
    UIColor * maxColor = [UIColor cyanColor];
    
    NSInteger count = 10;
    
    NSArray * colors = [UIColor colorArrayByStartColor:defaultColor andEndColor:maxColor andArrayCount:count];
    
    NSInteger level = ((FWPlane *)plane).planeLevel;
    
    UIColor * color = nil;
    if (colors.count > 0 && level<=count) {
        color = colors[level-1];
    }else if(colors.count<=0){
        color = defaultColor;
    }else if (level>count){
        color = maxColor;
    }else{
        color = defaultColor;
    }
    
    
    switch (level) {
        case 1:
            attack = 50;
            speed = FWBulletFlySpeed;
            
            break;
        case 2:
            attack = 100;
            speed = FWBulletFlySpeed+100.0;
            break;
        case 3:
            attack = 200;
            speed = FWBulletFlySpeed+100.0;
            break;

        default:
            attack = ((FWPlane *)plane).planeLevel * 100;
            speed = FWBulletFlySpeed+100.0;
            break;
    }
    
    

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
