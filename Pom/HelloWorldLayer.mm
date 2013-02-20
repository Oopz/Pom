//
//  HelloWorldLayer.mm
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright Oopz 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
				
		// init physics
		[self initPhysics];
		
		//Set up sprite
		CCSprite *sprite = [CCSprite spriteWithFile:@"bg.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		[self addChild:sprite z:-1];
		
		sprite = [CCSprite spriteWithFile:@"catapult_base_2.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		sprite.position = CGPointMake(181.0f, FLOOR_HEIGHT);
		[self addChild:sprite z:0];
		
		sprite = [CCSprite spriteWithFile:@"squirrel_1.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		sprite.position = CGPointMake(11.0f, FLOOR_HEIGHT);
		[self addChild:sprite z:0];
		
		sprite = [CCSprite spriteWithFile:@"catapult_base_1.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		sprite.position = CGPointMake(181.0f, FLOOR_HEIGHT);
		[self addChild:sprite z:9];
		
		sprite = [CCSprite spriteWithFile:@"squirrel_2.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		sprite.position = CGPointMake(240.0f, FLOOR_HEIGHT);
		[self addChild:sprite z:9];
		
		sprite = [CCSprite spriteWithFile:@"fg.png"];
		sprite.anchorPoint = CGPointMake(0, 0);
		[self addChild:sprite z:10];
		
		// Create the catapult's arm
		CCSprite *arm = [CCSprite spriteWithFile:@"catapult_arm.png"];
		//arm.anchorPoint = CGPointMake(0, 0);
		//arm.position = CGPointMake(230.0f/PTM_RATIO, (FLOOR_HEIGHT+91.0f)/PTM_RATIO);
		[self addChild:arm z:1];
		
		b2BodyDef armBodyDef;
		armBodyDef.type = b2_dynamicBody;
		armBodyDef.linearDamping = 1;
		armBodyDef.angularDamping = 1;
		armBodyDef.position.Set(230.0f/PTM_RATIO, (FLOOR_HEIGHT+91.0f)/PTM_RATIO);
		armBodyDef.userData = arm;
		armBody = world->CreateBody(&armBodyDef);
		
		b2PolygonShape armBox;
		b2FixtureDef armBoxDef;
		armBoxDef.shape = &armBox;
		armBoxDef.density = 0.3F;
		armBox.SetAsBox(11.0f/PTM_RATIO, 91.0f/PTM_RATIO);
		armFixture = armBody->CreateFixture(&armBoxDef);
		
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	groundBox.Set(b2Vec2(0, FLOOR_HEIGHT/PTM_RATIO), b2Vec2(s.width * 2.0f/PTM_RATIO, FLOOR_HEIGHT/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0, s.height/PTM_RATIO), b2Vec2(s.width * 2.0f/PTM_RATIO, s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0, s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s. width * 2.0f/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}


-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	
	
	for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
		if(b->GetUserData() != NULL) {
			CCSprite *ballData = (CCSprite *)b->GetUserData();
			ballData.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
	
	
	
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
