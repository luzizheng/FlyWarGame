//
//  GameCxt.h
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCxt : NSObject
+ (GameCxt *)sharedInstance;


@property(nonatomic,assign)GameStatus gameStatus;


@property(nonatomic,copy)void(^expAddingStepHandler)(GameCxt * cxt,CGFloat exp);

-(void)addExp:(CGFloat)exp;

@end

#define GCxt [GameCxt sharedInstance]
