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
@end
