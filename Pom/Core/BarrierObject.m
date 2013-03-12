//
//  BarrierObject.m
//  Pom
//
//  Created by Bill on 10/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import "BarrierObject.h"


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
		
		if (isEnemy) {
			self.maxlife = 1;
			self.life = 1;
		}else {
			self.maxlife = 5;
			self.life = 5;			
		}
		
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
