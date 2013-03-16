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
		MyAnimBatchNode *bearNode = [MyAnimBatchNode batchNodeWithName:@"bear"];
		// coz the content size only can be acknowledged by each CCSprite frame, but BatchNode can't tell
		//bearNode.position = ccp(winSize.width/2, bearFrame.contentSize.height/2 + 20);
		bearNode.position = ccp(winSize.width/2, 80);
		[self addChild:bearNode z:2];
				
	}
	return self;
}

- (void)dealloc {
	
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
