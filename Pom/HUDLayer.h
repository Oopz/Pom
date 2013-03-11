//
//  HUDLayer.h
//  Pom
//
//  Created by Bill on 22/2/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "MainScene.h"

@interface HUDLayer : CCLayer {
	BOOL _isNext;
    BOOL _isPause;
	BOOL _isRestart;
	
	CCMenu *_menuAsset;
	
	CCLabelTTF *_itemScore;
	
	CCMenu *_menuButtonAsset;
	CCMenu *_menuButtonRestart;
}

@property (nonatomic, assign) BOOL isNext;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isRestart;

@property (nonatomic, strong) CCMenu *menuAsset;
@property (nonatomic, strong) CCLabelTTF *itemScore;

@property (nonatomic, strong) CCMenu *menuButtonAsset;
@property (nonatomic, strong) CCMenu *menuButtonRestart;

- (void) reset;

- (void) showMessage:(NSString*)message;
- (void) showMenu:(BOOL)won;
- (void) hideMenu;
- (void) addAsset;
- (void) showAsset;
- (void) hideAsset;

- (void) updateScore:(NSInteger)score;

@end
