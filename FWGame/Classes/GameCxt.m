//
//  GameCxt.m
//  FWGame
//
//  Created by Luzz on 2017/9/13.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "GameCxt.h"

@implementation GameCxt
static GameCxt *sharedInstance = nil;
+ (GameCxt *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameCxt alloc] init];

    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gameScore = 0;
    }
    return self;
}

-(void)addExp:(CGFloat)exp
{
    
    if (self.expAddingStepHandler) {
        self.expAddingStepHandler(self,exp);
    }
}

-(void)setGameScore:(NSInteger)gameScore
{
    _gameScore = gameScore;
    
    if (gameScore > self.historyScore) {
        [[NSUserDefaults standardUserDefaults] setValue:@(gameScore) forKey:@"history_score"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.hasBrokenRecord = YES;
    }
    
}


-(NSInteger)historyScore
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"history_score"] integerValue];
}


-(NSInteger)gameLevel
{
    NSDecimalNumber * scoreNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)self.gameScore]];
    NSDecimalNumber * stepNum = [NSDecimalNumber decimalNumberWithString:@"200"];
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber * levelNum = [scoreNum decimalNumberByDividingBy:stepNum withBehavior:handler];
    return levelNum.integerValue+1;
}
-(void)clearCxt
{
    self.gameScore = 0;
    self.hasBrokenRecord = NO;
    self.gameStatus = GameStatusNormal;
}

@end
