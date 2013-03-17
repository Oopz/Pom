//
//  BarrierObject.m
//  Pom
//
//  Created by Bill on 10/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import "BarrierObject.h"


@implementation BarrierObject

- (id) initWithTexture:(NSString *)texture type:(BarrierObjectType)type position:(CGPoint)position rotation:(float)rotation isCircle:(BOOL)isCircle isStatic:(BOOL)isStatic {
	
    self = [super init];
    if (self) {		
		self.type = type;
		
		//self.isSprite = NO;
        self.texture = texture;
		self.position = position;
		self.rotation = rotation;
		self.isCircle = isCircle;
		self.isStatic = isStatic;
		self.isViolable = YES;
		//self.isEnemy = isEnemy;
		
		if (isStatic) {
			self.isViolable = NO;
		}
		
		if (type == BOT_Enemy) {
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
		self.type = BOT_Sprite;
		
		//self.isSprite = YES;
		self.texture = texture;
		self.anchor = anchor;
		self.position = position;
		self.zindex = zindex;
		self.isViolable = NO;
	}
	return self;
}

- (id) initAsBullet:(NSString *)texture {
	self = [super init];
	
	if (self) {
		self.type = BOT_Bullet;
		
		self.texture = texture;
		
		self.density = 5.0f; // 0.8
		self.isCircle = YES;
		self.radius = 10.0f; //15.0
		self.restitution = 0.2f;
		self.friction = 0.99f;
		
		self.isViolable = NO;
		
	}
	
	return self;
}


@end
