//
//  FWBullet.m
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWBullet.h"
#import "FWPlane.h"
@interface FWBullet()

@property(nonatomic,readwrite)NSInteger attack;
@property(nonatomic,readwrite)CGFloat bulletSpeed;
@end

@implementation FWBullet
+(instancetype)bulletWithParentPlane:(__kindof SKSpriteNode *)plane;
{
    
    NSString * bulletName = @"";
    
    CGFloat bullet_w = plane.size.width/5;
    CGFloat bullet_h = bullet_w;
    
    NSInteger attack = 0;
    CGFloat speed = 0;
    
    switch (((FWPlane *)plane).planeLevel) {
        case 1:
            bulletName = @"bullet_1";
            attack = 100;
            speed = FWBulletFlySpeed;
            break;
        case 2:
            bulletName = @"bullet_2";
            bullet_w = bullet_w*2;
            attack = 200;
            speed = FWBulletFlySpeed+50.0;
            break;
        case 3:
            bulletName = @"bullet_3";
            bullet_w = bullet_w*3;
            attack = 300;
            speed = FWBulletFlySpeed+100.0;
            break;
            
        default:
            break;
    }
    
    
    
    FWBullet * bullet = [[FWBullet alloc] initWithImageNamed:bulletName andAttack:attack andSpeed:speed];
    
    bullet.attack = attack;
    
    bullet.size = CGSizeMake(bullet_w, bullet_h);
    
    SKPhysicsBody * physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    physicsBody.dynamic = YES;
    physicsBody.restitution = 1.0;
    physicsBody.charge = 0.5;
    physicsBody.mass = 100;
    physicsBody.density = 100;
    physicsBody.categoryBitMask = GamePhyBullet_Major;
    physicsBody.collisionBitMask = GamePhyPlane_Enemy;
    physicsBody.contactTestBitMask = GamePhyPlane_Enemy;
    bullet.physicsBody = physicsBody;
    
    bullet.name = @"bullet";
    
    bullet.zPosition = GameLayerSprite;
    
    return bullet;
    
    
}


-(instancetype)initWithImageNamed:(NSString *)name andAttack:(NSInteger)attack andSpeed:(CGFloat)speed
{
    if (self = [super initWithImageNamed:name]) {
        self.attack = attack;
        self.bulletSpeed = speed;
    }
    return self;
}




@end
