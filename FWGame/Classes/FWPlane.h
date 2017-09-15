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

-(instancetype)initWithImageNamed:(NSString *)name isMajorPlane:(BOOL)isMajorPlane;


-(void)hitByAttack:(NSInteger)attackValue;

@property(nonatomic,readonly)NSTimeInterval bulletRate;
-(void)fireBullet;

-(void)stopFireBullet;

-(void)enemyFlyDown;


@end
