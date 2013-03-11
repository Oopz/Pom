//
//  Barrier.h
//  Pom
//
//  Created by Bill on 5/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

//#import <Foundation/Foundation.h>

#include "cocos2d.h"


@interface Barrier : NSObject


@property (atomic, retain) NSMutableArray * elements;



+ (id) getBarrier:(NSInteger)bid;

@end
