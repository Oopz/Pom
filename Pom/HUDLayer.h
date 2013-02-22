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
    BOOL _isPause;
	BOOL _isRestart;
	
	CCMenu *_menuAsset;
	
	CCLabelTTF *_itemScore;
}

@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isRestart;

@property (nonatomic, strong) CCMenu *menuAsset;
@property (nonatomic, strong) CCLabelTTF *itemScore;

- (void) reset;

- (void) showMessage:(NSString*)message;
- (void) showMenu:(BOOL)won;
- (void) hideMenu;
- (void) showAsset;

- (void) updateScore:(NSInteger)score;

@end
