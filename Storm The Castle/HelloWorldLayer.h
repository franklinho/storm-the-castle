//
//  HelloWorldLayer.h
//  Storm The Castle
//
//  Created by Franklin Kintai Ho on 10/30/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite *_player;
    NSMutableArray *_walls;
    CCAction *_walkAction;
    CCAction *_moveAction;
    CCLabelTTF *_scoreLabel;
    int _score;
    int _oldScore;
    CCParallaxNode *_backgroundNode;
    CCSprite *_background1;
    CCSprite *_background2;
    CCSprite *_background3;

}

@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, assign) CCLabelTTF *scoreLabel;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
