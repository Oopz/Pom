//
//  MainScene.m
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//


#import "MainScene.h"

#import "HelloWorldLayer.h"

@implementation MainSceneLayer

@synthesize bgElement = _bgElement;
@synthesize bgElementAction1 = _bgElementAction1;
@synthesize bgElementAction2 = _bgElementAction2;

@synthesize bgStatic = _bgStatic;

- (id) init {
	if((self = [super init])) {
		[CCMenuItemFont setFontSize:22];
		
		CCMenuItemLabel *itemStart = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
			NSLog(@"start");
			
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
		}];
		
		CCMenuItemLabel *itemSkill = [CCMenuItemFont itemWithString:@"Skill" block:^(id sender) {
			NSLog(@"skill");
		}];
		
		CCMenuItemLabel *itemShop = [CCMenuItemFont itemWithString:@"Shop" block:^(id sender) {
			NSLog(@"shop");
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemStart, itemSkill, itemShop, nil];
		
		//[menu alignItemsVertically];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[menu alignItemsHorizontallyWithPadding:40.0];		
		menu.position = ccp(winSize.width/2, 22);
		
		
		[self addChild:menu z:255]; // most front
		
		
		
		
		// static background
		self.bgStatic = [CCSprite spriteWithFile:@"bg_static.png"];
		self.bgStatic.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:_bgStatic z:-1];
		
		
		
		// background animate
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bear_anim.plist"];
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"bear_anim.png"];
		[self addChild:spriteSheet z:2];
		
		NSMutableArray *bgAnimFrames = [NSMutableArray array];
		for(int i=1; i<=8; ++i) {
			[bgAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bear%d.png", i]]];
		}
		
		CCAnimation *bgAnim = [CCAnimation animationWithSpriteFrames:bgAnimFrames delay:0.1f];
		self.bgElement = [CCSprite spriteWithSpriteFrameName:@"bear1.png"];
		_bgElement.position = ccp(winSize.width/2, _bgElement.contentSize.height/2 + 20);
		self.bgElementAction1 = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bgAnim]];
		[_bgElement runAction:_bgElementAction1];
		[spriteSheet addChild:_bgElement];
		
		
		
	}
	return self;
}

- (void)dealloc {
	self.bgElement = nil;
	self.bgElementAction1 = nil;
	self.bgElementAction2 = nil;
	
	self.bgStatic = nil;
	
	[super dealloc];
}

@end


@implementation MainScene

- (id) init {
	if((self = [super init])) {
		self.layer = [MainSceneLayer node];
		[self addChild:_layer];
	}
	return self;
}

@end
