//
//  MyCCSprite.m
//  Pom
//
//  Created by Bill on 11/3/13.
//  Copyright 2013 Oopz. All rights reserved.
//

#import "MyCCSprite.h"


@implementation MyCCSprite

- (id) initWithFile:(NSString *)filename {
	
	self = [super initWithFile:filename];
	if (self) {
		// Shader Effect
		// Reference to: http://www.raywenderlich.com/10862/how-to-create-cool-effects-with-custom-shaders-in-opengl-es-2-0-and-cocos2d-2-x
		
		const GLchar * fragmentSource = (GLchar*)[[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePathIgnoringResolutions:@"Mask.frag"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
		
		self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert fragmentShaderByteArray:fragmentSource];
		
		[self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
		[self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
		[self.shaderProgram link];
		[self.shaderProgram updateUniforms];
		
		colorRampUniformLocation = glGetUniformLocation(self.shaderProgram->_program, "u_colorRampTexture");
		glUniform1i(colorRampUniformLocation, 1);
		
		timeUniformLocation = glGetUniformLocation(self.shaderProgram->_program, "u_time");
		
		flagUniformLocation = glGetUniformLocation(self.shaderProgram->_program, "u_flag");
		glUniform1i(flagUniformLocation, 0);
		
		// Load your mask texture and disable linear interpolation on it, since you want raw values here.
		colorRampTexture = [[CCTextureCache sharedTextureCache] addImage:@"colorRamp.png"];
		[colorRampTexture setAliasTexParameters];
		
		[self.shaderProgram use];
		glActiveTexture(GL_TEXTURE1);
		glBindTexture(GL_TEXTURE_2D, [colorRampTexture name]);
		glActiveTexture(GL_TEXTURE0);
		
		
		[self scheduleUpdate];
	}
	
	return self;
}

- (void) enableMaskEffect {
	[self.shaderProgram use];
	glUniform1i(flagUniformLocation, 1);
}

- (void) disableMaskEffect {
	[self.shaderProgram use];
	glUniform1i(flagUniformLocation, 0);
}

- (void) createAffterEffect {
	//CCParticleExplosion *explosion = [[CCParticleExplosion alloc] initWithTotalParticles:70];
	
	CCParticleSun* explosion = [[CCParticleSun alloc] init];
	explosion.autoRemoveOnFinish = YES;
	explosion.startSize = 1.0f;
	explosion.anchorPoint = ccp(0.5f, 0.5f);
	explosion.positionType = kCCPositionTypeRelative;
	explosion.position = self.position;
	
	// _duration
	explosion.duration = 0.1f;
	explosion.emissionRate = explosion.totalParticles/explosion.duration;
	explosion.emitterMode = kCCParticleModeGravity;
	
	// Gravity Mode: gravity
	explosion.gravity = ccp(0,0);
	
	// Gravity Mode: speed of particles
	explosion.speed = 70;
	explosion.speedVar = 40;
	
	// Gravity Mode: radial
	explosion.radialAccel = 0;
	explosion.radialAccelVar = 0;
	
	// Gravity Mode: tagential
	explosion.tangentialAccel = 0;
	explosion.tangentialAccelVar = 0;
	
	// _angle
	explosion.angle = 90;
	explosion.angleVar = 360;
	
	// _life of particles
	explosion.life = 2.0f;
	explosion.lifeVar = 2;
	
	// size, in pixels
	//explosion.startSize = 15.0f;
	//explosion.startSizeVar = 10.0f;
	explosion.endSize = kCCParticleStartSizeEqualToEndSize;
	
	[self.parent addChild:explosion z:11];
	[explosion release]; // release it coz it doesn't stick to class variable - particleEffect
}

- (void) createEffect {
	
	NSLog(@"calling createEffect");
	
	/*
	particleEffect = [[CCParticleSun alloc] initWithTotalParticles:400];
	particleEffect.emissionRate=400.0f; // i added it for a faster emission
	particleEffect.autoRemoveOnFinish = YES;
	particleEffect.startSize = 20.0f;
	particleEffect.speed = 10.0f;
	particleEffect.gravity = ccp(-80, 0);
	particleEffect.anchorPoint = ccp(0.5f, 0.5f);
	particleEffect.position = self.position;
	//particleEffect.positionType = kCCPositionTypeFree;
	//particleEffect.positionType = kCCPositionTypeGrouped;
	particleEffect.duration = 1.0f;
	*/
	
	
	particleEffect = [[CCParticleMeteor alloc] init];
	//[particleEffect setTotalParticles:500];
	[particleEffect setGravity:ccp(0, 0)];
	[particleEffect setStartSize:20];
	[particleEffect setAutoRemoveOnFinish:YES];
	[particleEffect setEmissionRate:100];
	[particleEffect setLife:2];
	[particleEffect setDuration:5]; // how long the particle last
	[particleEffect setPositionType:kCCPositionTypeRelative];
	
	[self.parent addChild:particleEffect z:0];
}

- (void) removeEffect {
	[particleEffect removeFromParentAndCleanup:YES];
	particleEffect = nil;
}

- (void) update:(ccTime)delta {
	[super update:delta];
	
	elapsed += delta;
	
	[self.shaderProgram use];
	glUniform1f(timeUniformLocation, elapsed);
	
	if(particleEffect) {
		//CGPoint pos = [self convertToWorldSpace:self.position];
		particleEffect.position = self.position;
	}
}

- (void)dealloc
{
	if (particleEffect) {
		[self removeEffect];
	}
	
    [super dealloc];
}

@end
