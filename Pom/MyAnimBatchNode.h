//
//  MyAnimBatchNode.h
//  Pom
//
//  Created by Bill on 17/3/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyAnimBatchNode : CCSpriteBatchNode {
}

@property (nonatomic, assign) float animDelay;

+ (MyAnimBatchNode *)batchNodeWithName:(NSString*)name;

@end
