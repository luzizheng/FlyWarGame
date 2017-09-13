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


@interface GameScene()<SKPhysicsContactDelegate>
@property(nonatomic,strong)FWPlane * myPlane;
@property(nonatomic,strong)SpaceBgNode * spaceBackground;
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
    SKLabelNode * labelNode = [SKLabelNode labelNodeWithText:@"Fly War"];
    labelNode.fontSize = 80;
    labelNode.fontColor = [UIColor whiteColor];
    labelNode.position = CGPointMake(self.size.width/2, self.size.height/2);
    labelNode.zPosition = GameLayerUI;
    labelNode.alpha = 0.0;
    [self addChild:labelNode];
    [labelNode runAction:[SKAction fadeInWithDuration:2.0]];
    
    _label = labelNode;
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
                [self.myPlane runAction:[SKAction moveByX:direction.x y:direction.y duration:duration]];
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


// start game
-(void)startGame
{
    GCxt.gameStatus = GameStatusRunning;
    self.myPlane.position = FWGameStartPoint;
    [self addChild:self.myPlane];
    [self.myPlane runAction:[self fireBulletAction] withKey:@"fire"];
    
    // enemy plane
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[self enemyPlaneFlyOutAction],[SKAction waitForDuration:FWEnemyComeoutFrequency]]]] withKey:@"enemyPlaneFlyOutAction"];
    
    [self spaceBackgroundMoving];
    
}

// create a firing bullet action for plane
-(SKAction *)fireBulletAction
{
    SKAction * bulletFlyingAction = [SKAction runBlock:^{
        SKSpriteNode * bullet = [self.myPlane myBullet];
        bullet.position = CGPointMake(self.myPlane.position.x, self.myPlane.position.y + self.myPlane.size.height/2);
        [self addChild:bullet];
        NSTimeInterval duration = (self.size.height - bullet.position.y)/FWBulletFlySpeed;
        [bullet runAction:[SKAction sequence:@[
                                               [SKAction moveToY:self.size.height duration:duration],
                                               [SKAction removeFromParent]
                                               ]] withKey:@"bulletFlying"];
    }];
    return [SKAction repeatActionForever:[SKAction sequence:@[bulletFlyingAction,[SKAction waitForDuration:0.5]]]];
}

// create a action for one enemy come out
-(SKAction *)enemyPlaneFlyOutAction
{
    return [SKAction runBlock:^{
        FWPlane * plane = [self createEnemyPlane];
        [self addChild:plane];
        [plane runAction:[SKAction sequence:@[[SKAction moveToY:-plane.size.height duration:(self.size.height)/FWEnemyPlaneSpeed],
                                              [SKAction removeFromParent]
                                              ]]];
    }];
}

// create an enemy plane node
-(FWPlane *)createEnemyPlane
{
    FWPlane * plane = [[FWPlane alloc] initWithImageNamed:@"enem_1" isMajorPlane:NO];
    plane.HP = FWPlaneHP_Enemy;
    CGFloat xPosition = arc4random()&((int)(self.size.width-plane.size.width));
    xPosition += plane.size.width/2;
    plane.position = CGPointMake(xPosition, self.size.height+20);
    return plane;
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
    CGFloat dt = currentTime - _lastUpdateTime;
    
    
    _lastUpdateTime = currentTime;
}

#pragma mark - SKPhysicsContact delegate
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == GamePhyBullet_Major && contact.bodyB.categoryBitMask == GamePhyPlane_Enemy) {
        // enemy plane hit by you
        [self enemyPlane:contact.bodyB.node hitByBullet:contact.bodyA.node];
    }
    if (contact.bodyA.categoryBitMask == GamePhyPlane_Enemy && contact.bodyB.categoryBitMask == GamePhyBullet_Major) {
        // enemy plane hit by you
        [self enemyPlane:contact.bodyB.node hitByBullet:contact.bodyA.node];
    }
}

-(void)enemyPlane:(SKNode *)enemyPlane hitByBullet:(SKNode *)bullet
{
    if ([enemyPlane isKindOfClass:[FWPlane class]] && [bullet isKindOfClass:[SKSpriteNode class]]) {
        
        FWPlane * enemy = (FWPlane *)enemyPlane;
        SKSpriteNode * b = (SKSpriteNode *)bullet;
        
        NSInteger hp = enemy.HP;
        hp-=50;
        enemy.HP = hp;
        
        
        
    }
}


#pragma mark - lazy load

-(FWPlane *)myPlane
{
    if (!_myPlane) {
        _myPlane = [[FWPlane alloc] initWithImageNamed:@"myplane" isMajorPlane:YES];
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






@end
