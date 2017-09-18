//
//  SourceTool.m
//  FWGame
//
//  Created by Luzz on 2017/9/18.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "SourceTool.h"

@implementation SourceTool
+(NSString *)enemyImageNameByRandomWithGameLevel:(NSInteger)gameLevel
{
    NSDictionary * info = @{@"1":@"2",
                            @"2":@"3",
                            @"3":@"4",
                            @"4":@"3"
                            };
    
    
    if ([info.allKeys containsObject:KIntegerToString(gameLevel)]) {
        
        int number = [[info objectForKey:KIntegerToString(gameLevel)] intValue];
        
        int which = 1+arc4random()%number;
        
        return [NSString stringWithFormat:@"enem_%d_%d",(int)gameLevel,which];
        
    }else if(gameLevel<1){
        return nil;
    }else{
        // get the max level image name
        return [self enemyImageNameByRandomWithGameLevel:4];
    }
}
@end
