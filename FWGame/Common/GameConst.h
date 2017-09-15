//
//  GameConst.h
//  FWGame
//
//  Created by Luzz on 2017/9/11.
//  Copyright © 2017年 FW. All rights reserved.
//

#ifndef GameConst_h
#define GameConst_h


#endif /* GameConst_h */

// game layer
typedef enum : NSUInteger {
    GameStatusNormal,
    GameStatusRunning,
    GameStatusPause,
    GameStatusOver,
} GameStatus;

// physical layer
typedef enum : uint32_t {
    GamePhyNull = 0x00000000,
    GamePhyPlane_Major = 0x1 << 1,
    GamePhyBullet_Major = 0x1 << 2,
    GamePhyPlane_Enemy = 0x1 << 3,
    GamePhyBullet_Enemy = 0x1 << 4,
    GamePhyFireFlame = 0x1 << 5,
    GamePhyEdge = 0x1 << 6,
    GamePhyAll = 0xFFFFFFFF,
} GamePhy;

#define GameLayerBG -1.0
#define GameLayerSprite 0.0
#define GameLayerUI 1.0


#define FWGameStartPoint CGPointMake(self.size.width/2, self.size.height*0.2)

// 飞机前进(背景后移)速度
#define FWBackgroundMovingSpeed 200.0

// 敌机出现间隔时间
#define FWEnemyComeoutFrequency 1.5

// 敌机速度
#define FWEnemyPlaneSpeed 220.0

// 子弹飞行速度
#define FWBulletFlySpeed 800.0

// 主角飞机生命值
#define FWPlaneHP_Major 1000

// 敌机生命值
#define FWPlaneHP_Enemy 500

