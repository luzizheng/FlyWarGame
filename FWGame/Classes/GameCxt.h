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

/**
 *  start with 0;
 */
@property(nonatomic,assign)NSInteger gameScore;
/**
 *  base on game score (Start with 1)
 */
@property(nonatomic,readonly)NSInteger gameLevel;


@property(nonatomic,readonly)NSInteger historyScore;

@property(nonatomic,assign)BOOL hasBrokenRecord;


-(void)addExp:(CGFloat)exp;


-(void)clearCxt;

@end

#define GCxt [GameCxt sharedInstance]
