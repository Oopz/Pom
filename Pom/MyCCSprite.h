//
//  MyCCSprite.h
//  Pom
//
//  Created by Bill on 11/3/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MyCCSprite : CCSprite {
    CCParticleSystem * particleEffect;
}

- (void) createEffect;
- (void) removeEffect;

- (void) createAffterEffect;

@end
