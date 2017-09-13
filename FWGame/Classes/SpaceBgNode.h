//
//  SpaceBgNode.h
//  FWGame
//
//  Created by Luzz on 2017/9/12.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SpaceBgNode : SKSpriteNode
@property(nonatomic,readonly)CGSize spaceBgSize;
@property(nonatomic,readonly)CGFloat repeatHeight;
-(instancetype)initWithGameSceneSize:(CGSize)gsSize;
@end
