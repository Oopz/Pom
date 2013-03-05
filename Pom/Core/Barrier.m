//
//  Barrier.m
//  Pom
//
//  Created by Bill on 5/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import "Barrier.h"

#define FLOOR_HEIGHT 62.0f

@implementation BarrierObject

- (id) initWithTexture:(NSString *)texture position:(CGPoint)position rotation:(float)rotation isCircle:(BOOL)isCircle isStatic:(BOOL)isStatic isEnemy:(BOOL)isEnemy {
	
    self = [super init];
    if (self) {
		self.isSprite = NO;
        self.texture = texture;
		self.position = position;
		self.rotation = rotation;
		self.isCircle = isCircle;
		self.isStatic = isStatic;
		self.isEnemy = isEnemy;
		
		// not to define anchor point
    }
    return self;
}

- (id) initAsSprite:(NSString *)texture position:(CGPoint)position anchor:(CGPoint)anchor zindex:(float)zindex {
	self = [super init];
	if(self) {
		self.isSprite = YES;
		self.texture = texture;
		self.anchor = anchor;
		self.position = position;
		self.zindex = zindex;
	}
	return self;
}

@end



@implementation Barrier

+ (id) getBarrier:(NSInteger)bid {
	
	
	Barrier *barrier = [[Barrier alloc] init];
	
	if(bid == 1) {
		// sprites
		[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"bg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:-1]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"squirrel_1.png" position:ccp(11.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:0]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"catapult_base_1.png" position:ccp(181.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:9]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"squirrel_2.png" position:ccp(240.0f, FLOOR_HEIGHT) anchor:ccp(0, 0) zindex:9]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initAsSprite:@"fg.png" position:ccp(0, 0) anchor:ccp(0, 0) zindex:10]];
		
		// entities
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(675.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(741.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(741.0, FLOOR_HEIGHT+23.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_3.png" position:CGPointMake(672.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(707.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(707.0, FLOOR_HEIGHT+81.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(702.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_cat.png" position:CGPointMake(680.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(740.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		
		// 2 bricks at the right of the first block
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(770.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(770.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		// The dog between the blocks
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(830.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		
		// Second block
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_platform.png" position:CGPointMake(839.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:YES isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_cat.png" position:CGPointMake(881.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f+23.0f) rotation:0.0 isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(882.0, FLOOR_HEIGHT+108.0f) rotation:90.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
	}else{
		
		
		// entities
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(475.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(525.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(575.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(625.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(675.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(741.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(741.0, FLOOR_HEIGHT+23.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_3.png" position:CGPointMake(672.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(707.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(707.0, FLOOR_HEIGHT+81.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(702.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_cat.png" position:CGPointMake(680.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(740.0, FLOOR_HEIGHT+58.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		
		// 2 bricks at the right of the first block
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(770.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(770.0, FLOOR_HEIGHT+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
		// The dog between the blocks
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_dog.png" position:CGPointMake(830.0, FLOOR_HEIGHT) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		
		// Second block
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_platform.png" position:CGPointMake(839.0, FLOOR_HEIGHT) rotation:0.0f isCircle:NO isStatic:YES isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(854.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"head_cat.png" position:CGPointMake(881.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:YES isStatic:NO isEnemy:YES]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f) rotation:0.0f isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_1.png" position:CGPointMake(909.0, FLOOR_HEIGHT+28.0f+46.0f+23.0f) rotation:0.0 isCircle:NO isStatic:NO isEnemy:NO]];
		[barrier.elements addObject:[[BarrierObject alloc] initWithTexture:@"brick_2.png" position:CGPointMake(882.0, FLOOR_HEIGHT+108.0f) rotation:90.0f isCircle:NO isStatic:NO isEnemy:NO]];
		
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
