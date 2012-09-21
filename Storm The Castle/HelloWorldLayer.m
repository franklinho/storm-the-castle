//
//  HelloWorldLayer.m
//  Storm The Castle
//
//  Created by Franklin Kintai Ho on 10/30/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameOverScene.h"
#import "CCParallaxNode-Extras.h"
#import "StartScreenScene.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize player = _player;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;
@synthesize scoreLabel = _scoreLabel;

float timeInterval = 1.0;
float gameSpeed = 480;
int charLocation = 1;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to sceneß
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    if (sprite.tag=1) {
            [_walls removeObject:sprite];
    }
}



-(void)addBackground {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *bg1;
    //CCSprite *bg2;
    
    bg1 = [CCSprite spriteWithFile:@"GameBackgroundLong.png"];
    [bg1 setPosition:ccp(winSize.width/2, bg1.contentSize.height/2)];
    [bg1.textureAtlas.texture setAntiAliasTexParameters];
    [self addChild:bg1 z:0];
    
    /*bg2 = [CCSprite spriteWithFile:@"GameBackgroundLong.png"];
    [bg2 setPosition:ccp(winSize.width/2, bg1.contentSize.height)];
    [bg2.textureAtlas.texture setAntiAliasTexParameters];
    [self addChild:bg2 z:0];*/
    
    //Determine velocity of the background
    float backgroundSpeed = gameSpeed;
    
    //Determine distance of the background
    float bg1Distance = bg1.contentSize.height/2+winSize.height;
    //float bg2Distance = bg2.contentSize.height+winSize.height;
    
    // Determine duration of the background
    float bg1Duration = bg1Distance/backgroundSpeed;
    //float bg2Duration = bg2Distance/backgroundSpeed;
    
    // Create the actions
    id bg1Move = [CCMoveTo actionWithDuration:bg1Duration 
                                        position:ccp(winSize.width/2,-winSize.height)];
    /*id bg2Move = [CCMoveTo actionWithDuration:bg2Duration 
                                     position:ccp(winSize.width/2,-winSize.height)];*/
    
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    
    [bg1 runAction:[CCSequence actions:bg1Move,actionMoveDone, nil]];
    
    
    
}


-(void)addWall {

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int wallType = (arc4random() %2)+1;
    CCSprite *wall;
    int actualX;
    
    if (wallType == 2) {
    
        wall = [CCSprite spriteWithFile:(@"Wall2.png")]; 
    
        // Determine where to spawn the wall along the Y axis
        int spotNumber = 3;
        int randomSpot = (arc4random() % spotNumber) +1;
        actualX = (winSize.width*3/10)*randomSpot - winSize.width/10;
    }
    else {
        wall = [CCSprite spriteWithFile:(@"Wall1.png")]; 
        // Determine where to spawn the wall along the Y axis
        int spotNumber =2;
        int randomSpot = (arc4random() % spotNumber) +1;
        actualX = (winSize.width*3/10)*randomSpot + winSize.width/20;    
    }
        
    // Create the wall slightly off-screen along the top edge,
    // and along a random position along the X axis as calculated above
    wall.position = ccp(actualX, winSize.height + (wall.contentSize.height/2));
    [self addChild:wall z:1];
    
    
    //Determine velocity of the wall
    float wallSpeed = gameSpeed;
    
    //Determine distance of the wall
    float wallDistance = winSize.height+(wall.contentSize.height/2)+wall.contentSize.height/2;
    
    // Determine duration of the wall
    float actualDuration = wallDistance/wallSpeed;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(actualX,-wall.contentSize.height/2)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    [wall runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    /*CGPoint wallSpeed = ccp(1.0, 1.0);
    [_backgroundNode addChild:wall z:0 parallaxRatio:wallSpeed positionOffset:ccp(actualX, winSize.height + (wall.contentSize.height/2))];*/
    
    
    wall.tag=1;
    [_walls addObject:wall];
    
    _score+=gameSpeed/10;
    gameSpeed+=10;
    
    
}



-(void)gameLogic:(ccTime)dt {
    [self addWall];
    //[self addBackground];
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}

-(void)setPlayerPosition:(CGPoint)position {
	_player.position = position;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGPoint playerPos = _player.position;
    
    if (touchLocation.x > winSize.width/2) {
        if (charLocation < 3) {
            charLocation +=1;
        }
    }
    if (touchLocation.x < winSize.width/2) {
        if (charLocation >1) {
            charLocation -=1;
        }
    }
    
    
    playerPos.y=_player.contentSize.height/2;
    playerPos.x=(winSize.width*3/10)*charLocation - winSize.width/10;
    
    id actionMove = [CCMoveTo actionWithDuration:0.1
                                        position:ccp((winSize.width*3/10)*charLocation - winSize.width/10,_player.contentSize.height/2)];
    [_player runAction:[CCSequence actions:actionMove, nil]];
    //[self setPlayerPosition:playerPos];
}

- (void)update:(ccTime)dt {
    
    for (CCSprite *wall in _walls) {
        CGRect wallRect = CGRectMake(
                                           wall.position.x - (wall.contentSize.width/2), 
                                           wall.position.y - (wall.contentSize.height/2), 
                                           wall.contentSize.width, 
                                           wall.contentSize.height);
        
            CGRect playerRect = CGRectMake(
                                           _player.position.x - (_player.contentSize.width/2), 
                                           _player.position.y - (_player.contentSize.height/2), 
                                           _player.contentSize.width, 
                                           _player.contentSize.height);
            
            if (CGRectIntersectsRect(wallRect, playerRect)) {
                NSLog(@"ImpactDetected");
                GameOverScene *gameOverScene = [GameOverScene node];
                [gameOverScene.layer.label setString:@"You Lose :["];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
                _score = 0;
                _oldScore = -1;
                gameSpeed=480;
                break;
            }						
        }
    // Update score only when it changes for efficiency
    if (_score != _oldScore) {
        _oldScore = _score;
        [_scoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
    }
    
    CGPoint backgroundScrollVel = ccp(0,-gameSpeed);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, dt));
    
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_background1,_background2,_background3, nil];
    for (CCSprite *background in backgrounds) {
        if ([_backgroundNode convertToWorldSpace:background.position].y < -480) {
            [_backgroundNode incrementOffset:ccp(0,2000) forChild:background];
        }
    }
}



// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        StartScreenScene *startScreenScene = [StartScreenScene node];
        [[CCDirector sharedDirector] replaceScene:startScreenScene];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         @"HeroAnimation_default.plist"];
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                          batchNodeWithFile:@"HeroAnimation_default.png"];
        [self addChild:spriteSheet];
        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 12; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"HeroAnimation%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation 
                                 animationWithFrames:walkAnimFrames delay:0.05f];
        
        [self schedule:@selector(gameLogic:) interval:timeInterval];
        [self schedule:@selector(update:)];
        
        _walls = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
        
        /*CCSprite *bg = [CCSprite spriteWithFile:@"GameBackground.png"];
        bg.position=ccp(winSize.width/2,winSize.height/2);*/
        
        self.player = [CCSprite spriteWithSpriteFrameName:@"HeroAnimation1.png"];
        _player.position = ccp(winSize.width/2, _player.contentSize.height/2);
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        [_player runAction:_walkAction];
        
        //[self addChild:bg z:0];
        [self addChild:_player z:2];
        
        // Set up score and score label
        _score = 0;
        _oldScore = -1;
        self.scoreLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(100, 50) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:32];
        _scoreLabel.position = ccp(winSize.width/2, winSize.height-_scoreLabel.contentSize.height/2);
        _scoreLabel.color = ccc3(0,0,0);
        [self addChild:_scoreLabel z:3];

        // 1) Create the CCParallaxNode
        _backgroundNode = [CCParallaxNode node];
        [self addChild:_backgroundNode z:-1];
        
        // 2) Create the sprites we'll add to the CCParallaxNode
        _background1 = [CCSprite spriteWithFile:@"GameBackgroundLong.png"];
        _background2 = [CCSprite spriteWithFile:@"GameBackgroundLong.png"];
        _background3 = [CCSprite spriteWithFile:@"GameBackgroundLong.png"];
        
        [_background1.textureAtlas.texture setAntiAliasTexParameters];
        [_background2.textureAtlas.texture setAntiAliasTexParameters];
        [_background3.textureAtlas.texture setAntiAliasTexParameters];
        
        // 3) Determine relative movement speeds for space dust and background
        CGPoint backgroundSpeed = ccp(1.0,1.0);
        
        // 4) Add children to CCParallaxNode
        [_backgroundNode addChild:_background1 z:0 parallaxRatio:backgroundSpeed positionOffset:ccp(winSize.width/2,480)];
        [_backgroundNode addChild:_background2 z:0 parallaxRatio:backgroundSpeed positionOffset:ccp(winSize.width/2,1440)];
        [_backgroundNode addChild:_background3 z:0 parallaxRatio:backgroundSpeed positionOffset:ccp(winSize.width/2,2400)];
     
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    self.player = nil;
    [_walls release];
    _walls = nil;
    self.walkAction = nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
