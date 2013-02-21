//
//  MainScene.h
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "cocos2d.h"

@class MainSceneLayer;



@interface MainScene : CCScene {
}
@property (nonatomic, strong) MainSceneLayer * layer;
@end





@interface MainSceneLayer : CCLayer {
	CCSprite *_bgElement;
	CCAction *_bgElementAction1;
	CCAction *_bgElementAction2;
	
	CCSprite *_bgStatic;
}


@property (nonatomic, retain) CCSprite * bgElement;
@property (nonatomic, retain) CCAction * bgElementAction1;
@property (nonatomic, retain) CCAction * bgElementAction2;

@property (nonatomic, retain) CCSprite * bgStatic;

@end



