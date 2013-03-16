//
//  HUDLayer.h
//  Pom
//
//  Created by Bill on 22/2/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

#import "MainScene.h"

@interface HUDCCMenuItemImage : CCMenuItemImage
@property (nonatomic) SEL onPressDown;
@property (nonatomic) SEL onPressUp;
@end

@interface HUDLayer : CCLayer {
	BOOL _isNext;
    BOOL _isPause;
	BOOL _isRestart;
	BOOL _isPreserving;
	BOOL _isEjecting;
	
	CCMenu *_menuAsset;
	
	CCLabelTTF *_itemScore;
	
	CCMenu *_menuButtonAsset;
	CCMenu *_menuButtonRestart;
	
	CCMenu *_menuButtonEject;
}

@property (nonatomic, assign) BOOL isNext;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isRestart;
@property (nonatomic, assign) BOOL isPreserving;
@property (nonatomic, assign) BOOL isEjecting;

@property (nonatomic, strong) CCMenu *menuAsset;
@property (nonatomic, strong) CCLabelTTF *itemScore;

@property (nonatomic, strong) CCMenu *menuButtonAsset;
@property (nonatomic, strong) CCMenu *menuButtonRestart;

@property (nonatomic, strong) CCMenu *menuButtonEject;

- (void) reset;

- (void) showMessage:(NSString*)message;
- (void) showMenu:(BOOL)won;
- (void) hideMenu;
- (void) addAsset;
- (void) showAsset;
- (void) hideAsset;

- (void) showEject;
- (void) hideEject;

- (void) updateScore:(NSInteger)score;

@end
