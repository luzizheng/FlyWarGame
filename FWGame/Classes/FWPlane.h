//
//  FWPlane.h
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FWBullet.h"

@interface FWPlane : SKSpriteNode

/**
 *  defalut : 1
 */
@property(nonatomic,assign)NSUInteger planeLevel;

@property(nonatomic,assign)NSInteger HP;
@property(nonatomic,readonly)NSTimeInterval bulletRate;



-(instancetype)initWithImageNamed:(NSString *)name isMajorPlane:(BOOL)isMajorPlane;


+(instancetype)createEnemyPlane;

-(void)hitByAttack:(NSInteger)attackValue;


-(void)fireBullet;

-(void)stopFireBullet;

-(void)enemyFlyDown;


@end
