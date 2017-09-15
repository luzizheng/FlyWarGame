//
//  SKNode+Utils.m
//  FWGame
//
//  Created by Luzz on 2017/9/15.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "SKNode+Utils.h"

@implementation SKNode (Utils)
-(void)shakeWithTimes:(NSInteger)times;
{
    CGPoint initialPoint = self.position;
    NSInteger amplitudeX = 32;
    NSInteger amplitudeY = 2;
    NSMutableArray * randomActions = [NSMutableArray array];
    for (int i=0; i<times; i++) {
        NSInteger randX = self.position.x+arc4random() % amplitudeX - amplitudeX/2;
        NSInteger randY = self.position.y+arc4random() % amplitudeY - amplitudeY/2;
        SKAction *action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.01];
        [randomActions addObject:action];
    }
    
    SKAction *rep = [SKAction sequence:randomActions];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:rep completion:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.position = initialPoint;
    }];
    
}
@end
