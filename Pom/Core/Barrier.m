//
//  Barrier.m
//  Pom
//
//  Created by Bill on 5/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import "Barrier.h"
#import "BarrierObject.h"

#define FLOOR_HEIGHT 62.0f



@implementation Barrier

+ (id) getBarrier:(NSInteger)bid {
	
	
	Barrier *barrier = [[[Barrier alloc] init] autorelease];
	BarrierObject *object;
	
	if(bid == 1) {
		// sprites
		object = [[BarrierObject alloc] initAsSprite:@"bg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:-1];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initAsSprite:@"squirrel_1.png" position:ccp(11.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:0];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initAsSprite:@"catapult_base_1.png" position:ccp(181.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:9];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initAsSprite:@"squirrel_2.png" position:ccp(240.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:9];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initAsSprite:@"fg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:10];
		[barrier.elements addObject:object];
		
		// entities
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(675.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(741.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(741.0, FLOOR_HEIGHT+23.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_3.png" type:BOT_Block position:CGPointMake(672.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(707.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(707.0, FLOOR_HEIGHT+81.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(702.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_cat.png" type:BOT_Enemy position:CGPointMake(680.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(740.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		
		// 2 bricks at the right of the first block
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(770.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(770.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		// The dog between the blocks
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(830.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		
		// Second block
		object = [[BarrierObject alloc] initWithTexture:@"brick_platform.png" type:BOT_Block position:CGPointMake(839.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:YES];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_cat.png" type:BOT_Block position:CGPointMake(881.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f+23.0f) rotation:0.0 isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(882.0, FLOOR_HEIGHT+108.0f) rotation:90.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
	}else{
		//[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"bg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:-1]];
		
		//[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"brs_split_char.png" position:ccp(140.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:0]];
		
		//[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"brs_split_gun.png" position:ccp(175.0f, FLOOR_HEIGHT + 36) anchor:ccp(0, 0) zindex:9]];
		
		object = [[BarrierObject alloc] initAsSprite:@"fg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:10];
		[barrier.elements addObject:object];
		
		// entities
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(475.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(525.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(575.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(625.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(675.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(741.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(741.0, FLOOR_HEIGHT+23.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_3.png" type:BOT_Block position:CGPointMake(672.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(707.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(707.0, FLOOR_HEIGHT+81.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(702.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_cat.png" type:BOT_Enemy position:CGPointMake(680.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(740.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		
		// 2 bricks at the right of the first block
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(770.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(770.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
		// The dog between the blocks
		object = [[BarrierObject alloc] initWithTexture:@"head_dog.png" type:BOT_Enemy position:CGPointMake(830.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		
		// Second block
		object = [[BarrierObject alloc] initWithTexture:@"brick_platform.png" type:BOT_Block position:CGPointMake(839.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:YES];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"head_cat.png" type:BOT_Enemy position:CGPointMake(881.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:YES isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_1.png" type:BOT_Block position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f+23.0f) rotation:0.0 isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		object = [[BarrierObject alloc] initWithTexture:@"brick_2.png" type:BOT_Block position:CGPointMake(882.0, FLOOR_HEIGHT+108.0f) rotation:90.0f isCircle:NO isStatic:NO];
		[barrier.elements addObject:object];
		
	}
	
	return barrier;
}



- (id)init
{
    self = [super init];
    if (self) {
        self.elements = [[NSMutableArray alloc] init];		
		
    }
    return self;
}





- (void)dealloc
{
	for (BarrierObject *obj in self.elements) {
		[obj release];
	}
	
	
    [self.elements release];
	
	
    [super dealloc];
}



@end
