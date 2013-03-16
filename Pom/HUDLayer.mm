//
//  HUDLayer.m
//  Pom
//
//  Created by Bill on 22/2/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDCCMenuItemImage {
}

- (void) selected {
	[super selected];
	// Coz parent is CCMenuItem and grandpa is HUDLayer, set it self.parent.parent.
	[(HUDLayer*)self.parent.parent performSelector:self.onPressDown];
}

- (void) unselected {
	[super unselected];
	[(HUDLayer*)self.parent.parent performSelector:self.onPressUp];
}

@end


@implementation HUDLayer

@synthesize isNext = _isNext;
@synthesize isPause = _isPause;
@synthesize isRestart = _isRestart;
@synthesize isPreserving = _isPreserving;
@synthesize isEjecting = _isEjecting;

@synthesize menuAsset = _menuAsset;

@synthesize itemScore = _itemScore;

@synthesize menuButtonAsset = _menuButtonAsset;
@synthesize menuButtonRestart = _menuButtonRestart;
@synthesize menuButtonEject = _menuButtonEject;

- (id)init
{
    self = [super init];
    if (self) {
		[self reset];
		
		[self addAsset];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		CCMenuItemLabel *itemNext = [CCMenuItemFont itemWithString:@"Next" block:^(id sender) {
			NSLog(@"next");
			self.isNext = YES;
		}];
		itemNext.tag = 0;
		itemNext.color = ccc3(0, 255, 0);
		CCMenuItemLabel *itemResume = [CCMenuItemFont itemWithString:@"Resume" block:^(id sender) {
			NSLog(@"resume");
			[self hideMenu];
		}];
		itemResume.tag = 1;
		itemResume.color = ccc3(0, 255, 0);
		CCMenuItemLabel *itemRestart = [CCMenuItemFont itemWithString:@"Restart" block:^(id sender) {
			NSLog(@"restart");
			[self hideMenu];
			[self callbackRestart:sender];
		}];
		itemRestart.tag = 2;
		itemRestart.color = ccc3(0, 255, 0);
		CCMenuItemLabel *itemQuit = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {
			NSLog(@"quit");
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainScene node]]];
		}];
		itemQuit.tag = 3;
		itemQuit.color = ccc3(0, 255, 0);
		
		self.menuAsset = [CCMenu menuWithItems: itemNext, itemResume, itemRestart, itemQuit, nil];
		self.menuAsset.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:_menuAsset];
		
		[self hideMenu];
		
    }
    return self;
}

- (void) reset {
	_isNext = NO;
	_isPause = NO;
	_isRestart = NO;
	_isPreserving = NO;
	_isEjecting = NO;
}

- (void) addAsset {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// restart icon
	CCMenuItemImage *itemRestart = [CCMenuItemImage itemWithNormalImage:@"btn_round_foo_off.png" selectedImage:@"btn_round_foo_on.png" block:^(id sender){
		[self callbackRestart:sender];
	}];
	
	self.menuButtonRestart = [CCMenu menuWithItems:itemRestart, nil];
	self.menuButtonRestart.position = ccp(winSize.width - 40.0f, winSize.height - 40.0f);
	self.menuButtonRestart.visible = NO;
	[self addChild:self.menuButtonRestart];	
	
	// display menu icon
	CCMenuItemImage *itemShowMenu = [CCMenuItemImage itemWithNormalImage:@"btn_round_foo_off.png" selectedImage:@"btn_round_foo_on.png" block:^(id sender) {
			if(self.menuAsset.visible) {
				[self hideMenu];
			}else{
				[self showMenu:NO];
			}
		}
	];
	
	self.menuButtonAsset = [CCMenu menuWithItems:itemShowMenu, nil];
	self.menuButtonAsset.position = ccp(40.0f, winSize.height - 40.0f);
	self.menuButtonAsset.visible = NO;
	[self addChild:self.menuButtonAsset];
	
	// score label
	//self.itemScore = [CCLabelBMFont labelWithString:@"Score: 0" fntFile:@"Arial.fnt"];
	//self.itemScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Arial" fontSize:24];
	self.itemScore = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Yoshitoshi" fontSize:24];//Shockheaded
	self.itemScore.color = ccc3(255, 215, 0);
	self.itemScore.position = ccp(winSize.width/2, _itemScore.contentSize.height/2 + 2);
	[self addChild:self.itemScore];
	
	
	// preserving power to shoot icon
	/*
	HUDCCMenuItemImage *itemShowPreserving = [HUDCCMenuItemImage itemWithNormalImage:@"eject.png" selectedImage:@"eject.png"];
	itemShowPreserving.onPressDown = @selector(onEjectPressDown:);
	itemShowPreserving.onPressUp = @selector(onEjectPressUp:);
	itemShowPreserving.rotation = -30;
	itemShowPreserving.tag = 101;
	self.menuButtonEject = [CCMenu menuWithItems:itemShowPreserving, nil];
	self.menuButtonEject.position = ccp(winSize.width - 80, 80);
	self.menuButtonEject.visible = YES;
	[self addChild:self.menuButtonEject];
	*/
	
	
	
	// anim Eject icon
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"eject_anim.plist"];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for (int i=1; i<=32; ++i) {
		CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"eject%d.png", i]];
		
		if (spriteFrame) {
			[animFrames addObject:spriteFrame];	
		}else{
			break;
		}
	}
	
	CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:0.5f];
	CCSprite *animSprite = [CCSprite spriteWithSpriteFrameName:@"eject1.png"];
	//animSprite.position = ccp(winSize.width - 80, 80);
	CCAction *animAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
	[animSprite runAction:animAction];
	//[self addChild:animSprite];
	
	HUDCCMenuItemImage *itemShowPreserving = [HUDCCMenuItemImage itemWithNormalSprite:animSprite selectedSprite:nil];
	itemShowPreserving.onPressDown = @selector(onEjectPressDown:);
	itemShowPreserving.onPressUp = @selector(onEjectPressUp:);
	itemShowPreserving.rotation = -30;
	self.menuButtonEject = [CCMenu menuWithItems:itemShowPreserving, nil];
	self.menuButtonEject.position = ccp(winSize.width - animSprite.contentSize.width/2 - 20, animSprite.contentSize.height/2 + 20);
	self.menuButtonEject.visible = YES;
	[self addChild:self.menuButtonEject];
	

}

- (void) onEjectPressDown:(id) sender {
	self.isPreserving = YES;
	self.isEjecting = NO;
	NSLog(@"Preserving power...");
}

- (void) onEjectPressUp:(id) sender {
	self.isPreserving = NO;
	self.isEjecting = YES;
	
	NSLog(@"Eject!!");
}

- (void) hideAsset {
	self.menuButtonAsset.visible = NO;
	self.menuButtonRestart.visible = NO;
	self.itemScore.visible = NO;
}

- (void) showAsset {
	self.menuButtonAsset.visible = YES;
	self.menuButtonRestart.visible = YES;
	self.itemScore.visible = YES;
}

- (void) showEject {
	self.menuButtonEject.visible = YES;
}

- (void) hdieEject {
	self.menuButtonEject.visible = NO;
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
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// FIXME: there is a bug here when this message triggered before disappeared,
	//		  it will continue the former one action to disppear.
		
	// message
	CCLabelTTF * itemMessage = [CCLabelTTF labelWithString:message fontName:@"Yoshitoshi" fontSize:92];
	[self addChild:itemMessage];
	
	itemMessage.color = ccc3(255, 215, 0);
	itemMessage.scale = 0.0f;
	itemMessage.position = ccp(winSize.width/2, winSize.height/2);
	
	CCSequence *action = [CCSequence actions:
		[CCScaleTo actionWithDuration:1.0f scale:1.0f],
		[CCDelayTime actionWithDuration:3.0],
		[CCScaleTo actionWithDuration:1.0f scale:0.0f],
		[CCCallBlockN actionWithBlock:^(CCNode *node) {
			[self removeChild:itemMessage];
		}],
		nil];
	
	[itemMessage runAction:action];
}

- (void)dealloc
{
    self.menuAsset = nil;
	self.itemScore = nil;
	self.menuButtonAsset = nil;
	self.menuButtonRestart = nil;
	self.menuButtonEject = nil;
	
    [super dealloc];
}

@end
