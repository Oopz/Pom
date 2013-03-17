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
	float elapsed;
	
    CCParticleSystem * particleEffect;
	
	CCTexture2D * colorRampTexture;
	GLuint colorRampUniformLocation;
	GLuint timeUniformLocation;
	GLuint flagUniformLocation;
}

@property (nonatomic, strong) NSMutableDictionary *actions;

- (void) setupAnimation:(NSString*)name asAction:(NSString*)actionName startFrame:(int)startFrame endFrame:(int)endFrame;
- (void) playAnimation:(NSString*)actionName;

- (void) enableMaskEffect;
- (void) disableMaskEffect;

- (void) createEffect;
- (void) removeEffect;

- (void) createAffterEffect;

@end
