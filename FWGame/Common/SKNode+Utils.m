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


-(void)dropOutInfo:(NSString *)text andColor:(UIColor *)color andFontSize:(CGFloat)fontSize
{
    SKLabelNode * node = [SKLabelNode labelNodeWithText:text];
    node.fontSize = fontSize;
    node.fontColor = color;
    node.fontName = FWDefFontName;
    node.position = CGPointMake(self.position.x + 20, self.position.y+20);
    [self.parent addChild:node];
    [node runAction:[SKAction group:@[
                                      [SKAction moveBy:CGVectorMake(60.0, 60.0) duration:0.5],
                                      [SKAction fadeOutWithDuration:0.5]
                                      ]] withKey:@"infoDropOut"];
}


@end
