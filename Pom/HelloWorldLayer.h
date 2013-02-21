//
//  HelloWorldLayer.h
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright Oopz 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "MyContactListener.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
#define FLOOR_HEIGHT 62.0f

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
	
	b2Fixture *armFixture;
	b2Body *armBody;
	b2Body *groundBody;
	
	b2RevoluteJoint *armJoint;
	
	b2MouseJoint *mouseJoint;
	
	NSMutableArray *bullets;
	int currentBullet;
	
	b2Body *bulletBody;
	b2WeldJoint *bulletJoint;
	
	BOOL releasingArm;
	
	NSMutableSet *targets;
	NSMutableSet *enemies;
	
	MyContactListener *contactListener;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
