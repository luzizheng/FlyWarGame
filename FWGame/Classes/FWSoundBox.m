//
//  FWSoundBox.m
//  FWGame
//
//  Created by Luzz on 2017/9/14.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "FWSoundBox.h"
#import <AVFoundation/AVFoundation.h>



@interface FWSoundBox()<AVAudioPlayerDelegate>
@property(nonatomic,strong,readwrite)SKAction * boomSoundAction;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@end

@implementation FWSoundBox
static FWSoundBox *sharedInstance = nil;
+ (FWSoundBox *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FWSoundBox alloc] init];
    });
    return sharedInstance;
}




-(SKAction *)boomSoundAction
{
    if (!_boomSoundAction) {
        _boomSoundAction = [SKAction playSoundFileNamed:@"boom.mp3" waitForCompletion:NO];
    }
    return _boomSoundAction;
}
-(void)playBGM:(NSString *)bgmName
{
    [self playBGM:bgmName withExtension:@"mp3"];
}
-(void)playBGM:(NSString *)bgmName withExtension:(NSString *)ext;
{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bgmName withExtension:ext];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    // 4.设置循环播放
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}


@end
