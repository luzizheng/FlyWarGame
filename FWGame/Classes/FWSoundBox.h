//
//  FWSoundBox.h
//  FWGame
//
//  Created by Luzz on 2017/9/14.
//  Copyright © 2017年 FW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface FWSoundBox : NSObject

@property(nonatomic,strong,readonly)SKAction * boomSoundAction;

+ (FWSoundBox *)sharedInstance;


-(void)playBGM:(NSString *)bgmName;
-(void)playBGM:(NSString *)bgmName withExtension:(NSString *)ext;


@end

#define FWSB [FWSoundBox sharedInstance]
