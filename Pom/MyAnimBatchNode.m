//
//  MyAnimBatchNode.m
//  Pom
//
//  Created by Bill on 17/3/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import "MyAnimBatchNode.h"

@implementation MyAnimBatchNode


+ (MyAnimBatchNode *)batchNodeWithName:(NSString*)name {
	
	MyAnimBatchNode *batchNode = [MyAnimBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@_anim.png", name]];
	
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@_anim.plist", name]];
	
	NSMutableArray *animFrames = [NSMutableArray array];
	for (int i=1; i<=128; ++i) {
		CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@%d.png", name, i]];
		
		if (spriteFrame) {
			[animFrames addObject:spriteFrame];
		}else{
			break;
		}
	}
	
	CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:batchNode.animDelay];
	CCSprite *animSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@1.png", name]];
	CCAction *animAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
	[animSprite runAction:animAction];
	[batchNode addChild:animSprite];
	
	batchNode.estimateSize = CGSizeMake(animSprite.contentSize.width, animSprite.contentSize.height);
	
	return batchNode;
}


- (id)initWithFile:(NSString *)fileImage capacity:(NSUInteger)capacity {
	self = [super initWithFile:fileImage capacity:capacity];
	if(self != nil) {
		self.animDelay = 0.1f;
	}
	
	return self;
}


@end
