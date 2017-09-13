//
//  FWBullet.h
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>



@interface FWBullet : SKSpriteNode
@property(nonatomic,readonly)NSInteger attack;

@property(nonatomic,readonly)CGFloat bulletSpeed;

+(instancetype)bulletWithParentPlane:(__kindof SKSpriteNode *)plane;


@end
