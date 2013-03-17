//
//  BarrierObject.h
//  Pom
//
//  Created by Bill on 10/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"



typedef NS_ENUM(NSInteger, BarrierObjectType) {
    BOT_Enemy,
	BOT_Block,
	BOT_Bullet,
	BOT_Sprite
};


@interface BarrierObject : NSObject

@property (nonatomic, retain) NSString * texture;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint anchor;
@property (nonatomic, assign) float zindex;
@property (nonatomic, assign) float rotation;
//@property (nonatomic, assign) BOOL isSprite;
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, assign) BOOL isStatic;
@property (nonatomic, assign) BOOL isViolable;
//@property (nonatomic, assign) BOOL isEnemy;

@property (nonatomic, assign) BarrierObjectType type;

@property (nonatomic, assign) int maxlife;
@property (nonatomic, assign) int life;

@property (nonatomic, assign) float density;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float restitution;
@property (nonatomic, assign) float friction;

- (id) initWithTexture:(NSString*)texture type:(BarrierObjectType)type position:(CGPoint)position rotation:(float)rotation isCircle:(BOOL)isCircle isStatic:(BOOL)isStatic;

- (id) initAsSprite:(NSString*)texture position:(CGPoint)position anchor:(CGPoint)anchor zindex:(float)zindex;

- (id) initAsBullet:(NSString*)texture;

@end
