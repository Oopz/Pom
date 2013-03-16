//
//  MainScene.h
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "cocos2d.h"

#import "MyAnimBatchNode.h"

@class MainSceneLayer;



@interface MainScene : CCScene {
}
@property (nonatomic, strong) MainSceneLayer * layer;
@end





@interface MainSceneLayer : CCLayer {
	
	CCSprite *_bgStatic;
}

@property (nonatomic, retain) CCSprite * bgStatic;

@end



