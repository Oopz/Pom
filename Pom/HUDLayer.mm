//
//  HUDLayer.m
//  Pom
//
//  Created by Bill on 22/2/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

@synthesize isPause = _isPause;
@synthesize isRestart = _isRestart;

@synthesize menuAsset = _menuAsset;

@synthesize itemScore = _itemScore;

- (id)init
{
    self = [super init];
    if (self) {
		[self reset];
		
		[self showAsset];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CCMenuItemLabel *itemNext = [CCMenuItemFont itemWithString:@"Next" block:^(id sender) {
			NSLog(@"next");
		}];
		itemNext.tag = 0;
		itemNext.color = ccc3(0, 0, 255);
		CCMenuItemLabel *itemResume = [CCMenuItemFont itemWithString:@"Resume" block:^(id sender) {
			NSLog(@"resume");
			[self hideMenu];
		}];
		itemResume.tag = 1;
		itemResume.color = ccc3(0, 0, 255);
		CCMenuItemLabel *itemRestart = [CCMenuItemFont itemWithString:@"Restart" block:^(id sender) {
			NSLog(@"restart");
			[self hideMenu];
			[self callbackRestart:sender];
		}];
		itemRestart.tag = 2;
		itemRestart.color = ccc3(0, 0, 255);
		CCMenuItemLabel *itemQuit = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {
			NSLog(@"quit");
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainScene node]]];
		}];
		itemQuit.tag = 3;
		itemQuit.color = ccc3(0, 0, 255);
		
		self.menuAsset = [CCMenu menuWithItems: itemNext, itemResume, itemRestart, itemQuit, nil];
		self.menuAsset.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:_menuAsset];
		
		[self hideMenu];
    }
    return self;
}

- (void)reset {
	_isPause = NO;
	_isRestart = NO;
}

- (void)showAsset {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// restart icon
	CCMenuItemImage *itemRestart = [CCMenuItemImage itemWithNormalImage:@"btn_round_foo_off.png" selectedImage:@"btn_round_foo_on.png" block:^(id sender){
		[self callbackRestart:sender];
	}];
	
	CCMenu *menuBR = [CCMenu menuWithItems:itemRestart, nil];
	menuBR.position = ccp(winSize.width - 48, 32);
	[self addChild:menuBR];
	
	
	// menu icon
	CCMenuItemImage *itemShowMenu = [CCMenuItemImage itemWithNormalImage:@"btn_round_foo_off.png" selectedImage:@"btn_round_foo_on.png" block:^(id sender) {
		if(self.menuAsset.visible) {
			[self hideMenu];
		}else{
			[self showMenu:NO];
		}
	}];
	
	CCMenu *menuBL = [CCMenu menuWithItems:itemShowMenu, nil];
	menuBL.position = ccp(100, 32);
	[self addChild:menuBL];
	
	
	// score label
	self.itemScore = [CCLabelBMFont labelWithString:@"Score: 0" fntFile:@"Arial.fnt"];
	//self.itemScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Arial" fontSize:24];
	self.itemScore.position = ccp(winSize.width - _itemScore.contentSize.width/2 - 20.0f, winSize.height - _itemScore.contentSize.height/2 - 10.0f);
	//self.itemScore.color = ccc3(0, 0, 255);
	[self addChild:self.itemScore];
	
}

- (void) updateScore:(NSInteger)score {
	NSLog(@"updating score: %d", score);
	[self.itemScore setString:[NSString stringWithFormat:@"Score: %d", score]];
}

- (void)callbackRestart:(id)sender {
	self.isRestart = YES;
}

- (void)showMenu:(BOOL)won {
	if(won) {
		[self.menuAsset getChildByTag:0].visible = YES;
		[self.menuAsset getChildByTag:1].visible = NO;
		[self.menuAsset getChildByTag:2].visible = NO;
	}else{
		[self.menuAsset getChildByTag:0].visible = NO;
		[self.menuAsset getChildByTag:1].visible = YES;
		[self.menuAsset getChildByTag:2].visible = YES;
	}
	[self.menuAsset alignItemsVerticallyWithPadding:10.0f];
	self.menuAsset.visible = true;
}

- (void)hideMenu {
	self.menuAsset.visible = false;
}

- (void)showMessage:(NSString *)message {
	
}

- (void)dealloc
{
    self.menuAsset = nil;
	self.itemScore = nil;
	
    [super dealloc];
}

@end