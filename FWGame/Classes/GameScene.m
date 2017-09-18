//
//  GameScene.m
//  FWGame
//
//  Created by Luzz on 2017/9/11.
//  Copyright © 2017年 FW. All rights reserved.
//

#import "GameScene.h"
#import "SKTiledMap/SKTiledMap.h"
#import "SpaceBgNode.h"
#import "FWPlane.h"
#import "FWBullet.h"
#import "FWProgressNode.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AGSpriteButton.h"

@interface GameScene()<SKPhysicsContactDelegate>
@property(nonatomic,strong)FWPlane * myPlane;
@property(nonatomic,strong)SpaceBgNode * spaceBackground;
@property(nonatomic,strong)FWProgressNode * hpProgress;
@property(nonatomic,strong)FWProgressNode * exProgress;
@property(nonatomic,strong)SKLabelNode * levelLabel;
@property(nonatomic,strong)SKLabelNode * scoreLabel;
@end

@implementation GameScene {

    NSTimeInterval _lastUpdateTime;
    __weak SKLabelNode *_label;
    NSTimeInterval _touchTimeStamp;
}

- (void)sceneDidLoad {
    [super sceneDidLoad];
    
    GCxt.gameStatus = GameStatusNormal;
    self.backgroundColor = [UIColor blackColor];
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    [self insertChild:self.spaceBackground atIndex:0];
    
    // Initialize update time
    _lastUpdateTime = 0;
    
    // Get label node from scene and store it for use later
    SKLabelNode * labelNode = [self createLabelWithText:@"Fly War" andTextSize:80 andTextColor:[UIColor whiteColor]];
    labelNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    labelNode.zPosition = GameLayerUI;
    labelNode.alpha = 0.0;
    [self addChild:labelNode];
    [labelNode runAction:[SKAction fadeInWithDuration:2.0]];
    
    _label = labelNode;

    [FWSB playBGM:@"LoneSurvivor"];
    
    [self addEmitterNode];
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.size.width, self.size.height)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.fieldBitMask = GamePhyPlane_Major;
    self.physicsBody.categoryBitMask = GamePhyEdge;
    self.physicsBody.contactTestBitMask = GamePhyPlane_Major;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.restitution = 0.1;
    self.physicsBody.friction = 0.0;
    
    
    __weak typeof(self)weakSelf = self;
    GCxt.expAddingStepHandler = ^(GameCxt * cxt,CGFloat exp) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger nextLevelNeedExp = strongSelf.myPlane.planeLevel * 50;
        
        CGFloat currentExp = (CGFloat)nextLevelNeedExp * strongSelf.exProgress.progress;
        
        CGFloat latestExp = currentExp + exp;
        
        if (latestExp >= nextLevelNeedExp) {
            strongSelf.myPlane.planeLevel = strongSelf.myPlane.planeLevel+1;
            strongSelf.exProgress.progress = 0;
            [strongSelf showLevelUpTips];
            strongSelf.myPlane.HP = FWPlaneHP_Major;
            strongSelf.levelLabel.text = [NSString stringWithFormat:@"Lv:%ld",(long)strongSelf.myPlane.planeLevel];
            [strongSelf.levelLabel runAction:[SKAction sequence:@[[SKAction scaleXTo:5.0 y:5.0 duration:0.25],[SKAction scaleXTo:1.0 y:1.0 duration:0.25]]]];
        }else{
            
            strongSelf.exProgress.progress = latestExp/nextLevelNeedExp;
        }
        
        
        
        
    };
}


-(void)addEmitterNode
{
    SKEmitterNode * node = [SKEmitterNode nodeWithFileNamed:@"Bokeh.sks"];
    node.name = @"EmitterNode";
    node.position = CGPointMake(self.size.width/2, self.size.height/2);
    node.zPosition = GameLayerSprite;
    [self addChild:node];
    
}



-(void)removeFromParent{
    [self removeObserver:GCxt forKeyPath:@"score"];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    switch (GCxt.gameStatus) {
        case GameStatusNormal:[self dismissLabel];
            break;
        case GameStatusRunning:
        {
            _touchTimeStamp = event.timestamp;
        }
            break;
        default:
            break;
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (GCxt.gameStatus) {
        case GameStatusRunning:
            {
                UITouch * touch = touches.anyObject;
                CGPoint location = [touch locationInNode:self];
                CGPoint prevLocation = [touch previousLocationInNode:self];
                CGPoint direction = CGPointMake(location.x-prevLocation.x, location.y-prevLocation.y);
                NSTimeInterval duration = event.timestamp - _touchTimeStamp;
                _touchTimeStamp = event.timestamp;
                self.myPlane.physicsBody.velocity = CGVectorMake(direction.x/duration, direction.y/duration);
            }
            break;
            
        default:
            break;
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesOver:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesOver:touches withEvent:event];
}

-(void)touchesOver:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    switch (GCxt.gameStatus) {
        case GameStatusRunning:
        {
//            self.myPlane.physicsBody.velocity = CGVectorMake(0, 0);
        }
            break;
            
        default:
            break;
    }
}

-(void)dismissLabel
{
    __weak typeof(self)weakSelf = self;
    SKAction * tuningGrounp =  [SKAction group:@[
                      [SKAction scaleXBy:1.1 y:1.1 duration:0.5],
                      [SKAction scaleXBy:0.6 y:0.6 duration:0.5],
                      [SKAction moveTo:FWGameStartPoint duration:0.5],
                      [SKAction fadeOutWithDuration:0.5],
                      ]];
    [_label runAction:[SKAction sequence:@[
                                                tuningGrounp,
                                                [SKAction removeFromParent],
                                                ]] completion:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf startGame];
    }];
}


-(void)showGameOverLabel
{
    GCxt.gameStatus = GameStatusOver;
    SKLabelNode * gameOverLabel = [self createLabelWithText:@"Game Over" andTextSize:80 andTextColor:[UIColor whiteColor]];
    gameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + 40);
    gameOverLabel.name = @"gameOverLabel";
    
    
    SKLabelNode * score = [self createLabelWithText:[NSString stringWithFormat:@"Your Score:%ld History:%ld",(long)GCxt.gameScore,(long)GCxt.historyScore] andTextSize:30 andTextColor:[UIColor whiteColor]];
    score.position = CGPointMake(self.size.width/2, gameOverLabel.position.y - gameOverLabel.fontSize/2 - 20);;
    score.name = @"scoreReport";

    
    AGSpriteButton * restartLabel = [AGSpriteButton buttonWithColor:[UIColor clearColor] andSize:CGSizeMake(100, 40)];
    [restartLabel setLabelWithText:@"Exit" andFont:[UIFont fontWithName:FWDefFontName size:30] withColor:[UIColor whiteColor]];
    restartLabel.position = CGPointMake(self.size.width/2, gameOverLabel.position.y - gameOverLabel.fontSize/2 - 80);
    restartLabel.name = @"restartLabel";
    
    __weak typeof(restartLabel)weakNode = restartLabel;
    [restartLabel performAction:[SKAction sequence:@[[SKAction scaleXTo:3.0 y:3.0 duration:0.1],[SKAction scaleXTo:1.0 y:1.0 duration:0.1]]] onNode:weakNode withEvent:AGButtonControlEventTouchDown];
    
    __weak typeof(self)weakSelf = self;
    [restartLabel performBlock:^{
        
        [GCxt clearCxt];
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        GameScene * gs = [GameScene sceneWithSize:CGSizeMake(750, 1334)];
        [strongSelf.view presentScene:gs];
        
    } onEvent:AGButtonControlEventTouchUpInside];
    
    [self addChild:score];
    [self addChild:gameOverLabel];
    [self addChild:restartLabel];
    
    
    
}


// start game
-(void)startGame
{
    GCxt.gameStatus = GameStatusRunning;
    
    [[self childNodeWithName:@"EmitterNode"] removeFromParent];
    
    self.myPlane.position = FWGameStartPoint;
    [self addChild:self.myPlane];

    [self.myPlane fireBullet];
    
    // enemy plane
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[self enemyPlaneFlyOutAction],[SKAction waitForDuration:FWEnemyComeoutFrequency]]]] withKey:@"enemyPlaneFlyOutAction"];
    
    [self spaceBackgroundMoving];
    
    // score label
//    self.scoreLabel.position = CGPointMake(30, 30);
//    [self addChild:self.scoreLabel];
    [self addChild:self.hpProgress];
    SKLabelNode * hpLabel = [self createLabelWithText:@"HP" andTextSize:15 andTextColor:[UIColor whiteColor]];
    hpLabel.position = CGPointMake(self.hpProgress.position.x - self.hpProgress.size.width/2 - 30, self.hpProgress.position.y - 5);
    [self addChild:hpLabel];
    
    [self addChild:self.exProgress];
    SKLabelNode * expLabel = [self createLabelWithText:@"EXP" andTextSize:15 andTextColor:[UIColor whiteColor]];
    expLabel.position = CGPointMake(self.exProgress.position.x - self.exProgress.size.width/2- 30, self.exProgress.position.y -5);
    [self addChild:expLabel];
    
    
    self.scoreLabel.position = CGPointMake(30, self.size.height-40);
    [self addChild:self.scoreLabel];
    
    
    self.levelLabel.position = CGPointMake(hpLabel.position.x, hpLabel.position.y+25);
    self.levelLabel.text = [NSString stringWithFormat:@"Lv:%ld",(long)self.myPlane.planeLevel];
    [self addChild:self.levelLabel];
    
}


// create a action for one enemy come out
-(SKAction *)enemyPlaneFlyOutAction
{
    return [SKAction runBlock:^{
        FWPlane * plane = [self createEnemyPlane];
        if (plane) {
            [self addChild:plane];
            [plane enemyFlyDown];
        }
        
    }];
}

// create an enemy plane node
-(FWPlane *)createEnemyPlane
{
    FWPlane * plane = [FWPlane createEnemyPlane];
    if (plane) {
        plane.HP = FWPlaneHP_Enemy;
        CGFloat xPosition = arc4random()&((int)(self.size.width-plane.size.width));
        xPosition += plane.size.width/2;
        plane.position = CGPointMake(xPosition, self.size.height+20);
        return plane;
    }else{
        return nil;
    }
    
}


-(void)spaceBackgroundMoving
{
    CGFloat repeatHeight = self.spaceBackground.repeatHeight;
    NSTimeInterval duration = repeatHeight/FWBackgroundMovingSpeed;
    SKAction * action = [SKAction sequence:@[
                                             [SKAction moveToY:-repeatHeight duration:duration],
                                             [SKAction moveToY:0 duration:0]
                                             ]];
    [self.spaceBackground runAction:[SKAction repeatActionForever:action]];
    
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    

    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
//    NSTimeInterval dt = currentTime - _lastUpdateTime;
//
//    NSLog(@"dt = %.0f",dt);
    _lastUpdateTime = currentTime;
    
    switch (GCxt.gameStatus) {
        case GameStatusRunning:
            self.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)GCxt.gameScore];
            [self configMyPlaneHpValue];
            [self checkRemoveNode];
            break;
        case GameStatusOver:
            [self checkRemoveNode];
            break;
        default:
            break;
    }
    
}

-(void)configMyPlaneHpValue
{
    self.hpProgress.progress = ((CGFloat)self.myPlane.HP)/((CGFloat)FWPlaneHP_Major);
}


-(void)checkRemoveNode
{
    SKNode * bullet = [self childNodeWithName:@"bullet"];
    if (!CGRectContainsPoint(self.frame, bullet.position)) {
        [bullet removeFromParent];
        NSLog(@"one bullet out of screen has been removed");
    }
    
    if (sqrt(pow(bullet.physicsBody.velocity.dx, 2) + pow(bullet.physicsBody.velocity.dy, 2))<100) {
        [bullet removeFromParent];
    }
    
    SKNode * enemyPlane = [self childNodeWithName:@"enemyplane"];
    if (enemyPlane.position.y<0 || enemyPlane.position.x<-20 || enemyPlane.position.x > self.size.width+20) {
        [enemyPlane removeFromParent];
        NSLog(@"one enemy plane out of screen has been removed");
    }
    
    
}



-(void)showLevelUpTips
{
    SKLabelNode * label = [self createLabelWithText:@"Level Up!!!" andTextSize:80 andTextColor:[UIColor yellowColor]];
    label.position = CGPointMake(self.size.width/2, self.size.height/2 - 100);
    label.alpha = 0.0;
    [self addChild:label];
    [label runAction:[SKAction sequence:@[
                                          [SKAction group:@[[SKAction moveByX:0 y:200 duration:2.5],
                                                            [SKAction sequence:@[[SKAction fadeAlphaTo:1.0 duration:0.5],
                                                                                 [SKAction waitForDuration:1.5],
                                                                                 [SKAction fadeAlphaTo:0.0 duration:0.5]
                                                                                 ]]
                                                            ]],
                                          [SKAction removeFromParent]
                                          ]]];
    
}


#pragma mark - SKPhysicsContact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask+contact.bodyB.categoryBitMask == GamePhyPlane_Major+GamePhyBullet_Major) {
        // my plane hit by my bullet
        [self myPlaneHitBy:contact.bodyA.categoryBitMask == GamePhyPlane_Major?contact.bodyB.node:contact.bodyA.node];
    }
    if (contact.bodyA.categoryBitMask+contact.bodyB.categoryBitMask == GamePhyPlane_Major+GamePhyPlane_Enemy) {
        // my plane hit by enemy plane
        [self myPlaneHitBy:contact.bodyA.categoryBitMask == GamePhyPlane_Major?contact.bodyB.node:contact.bodyA.node];
    }
    
    if (contact.bodyA.categoryBitMask == GamePhyBullet_Major && contact.bodyB.categoryBitMask == GamePhyPlane_Enemy) {
        // enemy plane hit by you
        [self enemyPlane:contact.bodyB.node hitByBullet:contact.bodyA.node];
        
    }
    if (contact.bodyA.categoryBitMask == GamePhyPlane_Enemy && contact.bodyB.categoryBitMask == GamePhyBullet_Major) {
        // enemy plane hit by you
        [self enemyPlane:contact.bodyA.node hitByBullet:contact.bodyB.node];
    }
}

-(void)enemyPlane:(SKNode *)enemyPlane hitByBullet:(SKNode *)bullet
{
    if ([enemyPlane isKindOfClass:[FWPlane class]] && [bullet isKindOfClass:[SKSpriteNode class]]) {
        
        FWPlane * enemy = (FWPlane *)enemyPlane;
        FWBullet * b = (FWBullet *)bullet;
        
        if (enemy.HP>0) {
            
            BOOL criticalAttack = arc4random()%10<2?YES:NO; // 暴击
            NSInteger attack = criticalAttack?b.attack*2:b.attack;
            [enemy hitByAttack:attack];
            [enemy dropOutInfo:[NSString stringWithFormat:@"-%ld",attack] andColor:[UIColor redColor] andFontSize:criticalAttack?60:30];
            
        }
         
        
    }
}

-(void)myPlaneHitBy:(__kindof SKNode *)node;
{
    NSInteger attack = 50;
    if ([node isKindOfClass:[FWBullet class]]) {
        attack = [(FWBullet *)node attack];
    }
    
    if (self.myPlane.HP <= attack) {
        [self showGameOverLabel];
    }
    
    [self.myPlane hitByAttack:attack];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.myPlane dropOutInfo:[NSString stringWithFormat:@"-%ld",(long)attack] andColor:[UIColor redColor] andFontSize:30];
}


#pragma mark - lazy load

-(FWPlane *)myPlane
{
    if (!_myPlane) {
        _myPlane = [[FWPlane alloc] initWithImageNamed:@"myplane" isMajorPlane:YES];
        _myPlane.planeLevel = 1;
        _myPlane.HP = FWPlaneHP_Major; // 生命值
    }
    return _myPlane;
}

-(SpaceBgNode *)spaceBackground
{
    if (!_spaceBackground) {
        _spaceBackground = [[SpaceBgNode alloc] initWithGameSceneSize:self.size];
        _spaceBackground.name = @"space";
        _spaceBackground.anchorPoint = CGPointMake(0.0, 0.0);
        _spaceBackground.position = CGPointZero;
        _spaceBackground.zPosition = GameLayerBG;
    }
    return _spaceBackground;
}

//-(SKLabelNode *)scoreLabel
//{
//    if (!_scoreLabel) {
//        _scoreLabel = [SKLabelNode labelNodeWithText:@"0"];
//        _scoreLabel.name = @"scoreLabel";
//        _scoreLabel.fontSize = 40;
//        _scoreLabel.fontColor = [UIColor whiteColor];
//        _scoreLabel.zPosition = GameLayerUI;
//        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
//    }
//    return _scoreLabel;
//}

-(CGFloat)progressWidth
{
    return self.size.width/2;
}

-(FWProgressNode *)hpProgress
{
    if (!_hpProgress) {
        _hpProgress = [[FWProgressNode alloc] initWithRectOfSize:CGSizeMake([self progressWidth], 10) andStrokeColor:[UIColor whiteColor] andFillColor:[UIColor redColor]];
        _hpProgress.position = CGPointMake(80 + [self progressWidth]/2, 40);
        _hpProgress.progress = 1.0;
    }
    return _hpProgress;
}


-(FWProgressNode *)exProgress
{
    if (!_exProgress) {
        _exProgress = [[FWProgressNode alloc] initWithRectOfSize:CGSizeMake([self progressWidth], 10) andStrokeColor:[UIColor whiteColor] andFillColor:[UIColor greenColor]];
        _exProgress.position = CGPointMake(80 + [self progressWidth]/2, 20);
        _exProgress.progress = 0.0;
    }
    return _exProgress;
}

-(SKLabelNode *)createLabelWithText:(NSString *)text andTextSize:(CGFloat)textSize andTextColor:(UIColor *)color
{
    SKLabelNode * node = [SKLabelNode labelNodeWithText:text];
    node.fontSize = textSize;
    node.fontColor = color;
    node.fontName = FWDefFontName;
    node.zPosition = GameLayerUI;
    return node;
}

-(SKLabelNode *)levelLabel
{
    if (!_levelLabel) {
        _levelLabel = [self createLabelWithText:@"Lv:" andTextSize:25 andTextColor:[UIColor whiteColor]];
    }
    return _levelLabel;
}
-(SKLabelNode *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [self createLabelWithText:@"0" andTextSize:28 andTextColor:[UIColor whiteColor]];
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    }
    return _scoreLabel;
}
@end
