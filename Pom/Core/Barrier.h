//
//  Barrier.h
//  Pom
//
//  Created by Bill on 5/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

//#import <Foundation/Foundation.h>

#include "cocos2d.h"

@interface BarrierObject : NSObject

@property (nonatomic, retain) NSString * texture;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint anchor;
@property (nonatomic, assign) float zindex;
@property (nonatomic, assign) float rotation;
@property (nonatomic, assign) BOOL isSprite;
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, assign) BOOL isStatic;
@property (nonatomic, assign) BOOL isEnemy;

- (id) initWithTexture:(NSString*)texture position:(CGPoint)position rotation:(float)rotation isCircle:(BOOL)isCircle isStatic:(BOOL)isStatic isEnemy:(BOOL)isEnemy;

- (id) initAsSprite:(NSString*)texture position:(CGPoint)position anchor:(CGPoint)anchor zindex:(float)zindex;

@end





@interface Barrier : NSObject


@property (atomic, retain) NSMutableArray * elements;



+ (id) getBarrier:(NSInteger)bid;

@end
