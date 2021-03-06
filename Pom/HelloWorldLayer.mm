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

#import "SimpleAudioEngine.h"

#import "MyCCSprite.h"

#import "BarrierObject.h"

enum {
	kTagParentNode = 1,
};

typedef NS_ENUM(NSInteger, PomActionTag) {
    PomActionTagCamera
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

@synthesize hud = _hud;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// hud
	HUDLayer *hud = [HUDLayer node];
	layer.hud = hud;
	[scene addChild:hud z:64];// most front
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) createBullets {
	int count = [cartridge.objects count];
	currentBullet = 0;
	CGFloat pos = 62.0f;
	
	if(count > 0) {
		// delta is the spacing between corns
		// 62 is the position on the screen where we want the corns to start appearing
		// 165 is the position on the screen where we want the corns to stop appearing
		// 30 is the size of the corn
		CGFloat delta = (count > 1)?((165.0f - 62.0f -30.0f) / (count - 1)):0.0f;
		
		bullets = [[NSMutableArray alloc] initWithCapacity:count];
		for(int i=0; i<count; i++, pos+=delta) {
			BarrierObject *bulletObject = [cartridge.objects objectAtIndex:i];
			
			// Create the bullet
			MyCCSprite *sprite = [MyCCSprite spriteWithFile:bulletObject.texture];
			sprite.userData = bulletObject;
			[self addChild:sprite z:1];
						
			b2BodyDef bulletBodyDef;
			bulletBodyDef.type = b2_dynamicBody;
			bulletBodyDef.bullet = true;
			bulletBodyDef.position.Set(pos/PTM_RATIO, (FLOOR_HEIGHT+15.0f)/PTM_RATIO);
			bulletBodyDef.userData = sprite;
			b2Body * bullet = world->CreateBody(&bulletBodyDef);
			bullet->SetActive(false);
			
			
			b2FixtureDef ballShapeDef;
			if(bulletObject.isCircle) {
				b2CircleShape circle;
				circle.m_radius = bulletObject.radius/PTM_RATIO;
				ballShapeDef.shape = &circle;
			}else {
				b2PolygonShape box;
				// as a rect
				box.SetAsBox(bulletObject.radius/PTM_RATIO, 1.0f/PTM_RATIO);
				ballShapeDef.shape = &box;
			}
			
			ballShapeDef.density = bulletObject.density;
			ballShapeDef.restitution = bulletObject.restitution;
			ballShapeDef.friction = bulletObject.friction;
			bullet->CreateFixture(&ballShapeDef);
			
			[bullets addObject:[NSValue valueWithPointer:bullet]];
		}
	}
}

- (void) resetGame {
	
	[self stopAllActions];
	[self.hud hideAsset];
	
	// Previous bullets cleanup
	if (bullets) {
		for (NSValue *bulletPointer in bullets) {
			b2Body *bullet = (b2Body*)[bulletPointer pointerValue];
			CCNode *node = (CCNode*)bullet->GetUserData();
			[self removeChild:node cleanup:YES];
			world->DestroyBody(bullet);
		}
		[bullets release];
		bullets = nil;
	}
	
	// Previous targets cleanup
	if (targets) {
		for (NSValue *bodyValue in targets) {
			b2Body *body = (b2Body*)[bodyValue pointerValue];
			CCNode *node = (CCNode*)body->GetUserData();
			[self removeChild:node cleanup:YES];
			world->DestroyBody(body);
		}
		[targets release];
		[enemies release];
		targets = nil;
		enemies = nil;
	}
	
	// Clear the sprites which from Barrier file
	if(miscs) {
		for (CCSprite *sprite in miscs) {
			[self removeChild:sprite cleanup:YES];
		}
		[miscs release];
		miscs = nil;
	}
	
	// Clear the arm joint before.
	if(armJoint) {
		world->DestroyJoint(armJoint);
	}
	
	// Clear the arm body and its sprite before.
	if(armBody) {
		CCNode * armSprite = (CCSprite *)armBody->GetUserData();
		[self removeChild:armSprite cleanup:YES];
		
		world->DestroyBody(armBody);
	}	
	
	// Only set body & joint to nil, coz the bullet has been destroyed above
	if (bulletJoint != nil) {
		bulletJoint = nil;
	}
	if(bulletBody != nil) {
		bulletBody = nil;
	}
	releasingArm = NO;
	
	preservingFactor = 0;
	
	score = 0;
	[self.hud updateScore:score];
	
	[self setPosition:CGPointMake(0, 0)]; // we added it to reset the position to the catapult
	
	[self createBarrier];
	
	[self createBullets];
	
	CCFiniteTimeAction *camAction1 = [CCMoveTo actionWithDuration:1.5f position:CGPointMake(-480.0f, 0.0f)];
	CCFiniteTimeAction *camAction2 = [CCMoveTo actionWithDuration:1.5f position:CGPointMake(0, 0)];
	previewing = YES;
	[self runAction:
	 [CCSequence actions:
	  camAction1,
	  //[CCCallFuncN actionWithTarget:self selector:@selector(attachBullet)],
	  [CCDelayTime actionWithDuration:1.0f],
	  camAction2,
	  [CCCallBlockN actionWithBlock:
	   ^(CCNode *node) {
		   previewing = NO;
		   [self.hud showAsset];
	   }],
	  nil]];
	
	// show which barrier now
	[self.hud showMessage:[NSString stringWithFormat:@"Barrier %i !!", currentBarrier]];
	
	
}

- (void) resetBullet {
	[self stopActionByTag:PomActionTagCamera];
	
	if ([enemies count] == 0) {
		// game over
		//[self performSelector:@selector(resetGame) withObject:nil afterDelay:2.0f];
		[self.hud hideAsset];
		[self.hud showMenu:YES];
		
	}else if([self attachBullet]) {
		CCAction *camAction = [CCMoveTo actionWithDuration:2.0f position:CGPointMake(0, 0)];
		camAction.tag = PomActionTagCamera;
		[self runAction:camAction];
	}else {
		// We can reset the whole scene here
		//[self performSelector:@selector(resetGame) withObject:nil afterDelay:2.0f];
		[self.hud showMenu:NO];
	}
}

- (BOOL) attachBullet {
	if(currentBullet < [bullets count]) {
		bulletBody = (b2Body *)[[bullets objectAtIndex:currentBullet++] pointerValue];
		//bulletBody->SetTransform(b2Vec2(230.0/PTM_RATIO, (120.0f+FLOOR_HEIGHT)/PTM_RATIO), 0.0f);//155.0
		bulletBody->SetTransform(b2Vec2(20.0/PTM_RATIO, (40.0f+FLOOR_HEIGHT)/PTM_RATIO), 0.0f);//155.0
		bulletBody->SetActive(false);
		
		/*
		b2WeldJointDef weldJointDef;
		weldJointDef.Initialize(bulletBody, armBody, b2Vec2(230.0f/PTM_RATIO, (120.0f+FLOOR_HEIGHT)/PTM_RATIO));//155.0
		weldJointDef.collideConnected = false;
		
		bulletJoint = (b2WeldJoint *)world->CreateJoint(&weldJointDef);
		*/
		
		return YES;
	}
	return NO;
}

- (void) createTarget:(BarrierObject *)object {
	MyCCSprite *sprite = [MyCCSprite spriteWithFile:object.texture];
	//sprite.userObject=object;
	sprite.userData = object;// bind BarrierObject to sprite
	[self addChild:sprite z:1];
	
	b2BodyDef bodyDef;
	bodyDef.type = object.isStatic ? b2_staticBody : b2_dynamicBody;
	bodyDef.position.Set((object.position.x+sprite.contentSize.width/2.0f)/PTM_RATIO, (object.position.y+sprite.contentSize.height/2.0f)/PTM_RATIO);
	bodyDef.angle = CC_DEGREES_TO_RADIANS(object.rotation);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	b2FixtureDef boxDef;
	if(object.isCircle) {
		b2CircleShape circle;
		circle.m_radius = sprite.contentSize.width/2.0f/PTM_RATIO;
		boxDef.shape = &circle;
	}else {
		b2PolygonShape box;
		box.SetAsBox(sprite.contentSize.width/2.0f/PTM_RATIO, sprite.contentSize.height/2.0f/PTM_RATIO);
		boxDef.shape = &box;
	}
	
	
	if(object.type == BOT_Enemy) {
		//boxDef.userData = (void*)1;
		[enemies addObject:[NSValue valueWithPointer:body]];
	}
	
	boxDef.density = 0.5f;
	body->CreateFixture(&boxDef);
	
	[targets addObject:[NSValue valueWithPointer:body]];
}

- (void) createFort {
	
	
	// -- Set up the catapult arm --
	// Create the catapult's arm
	//CCSprite *arm = [CCSprite spriteWithFile:@"catapult_arm.png"];
	//arm.anchorPoint = CGPointMake(0, 0);
	//arm.position = CGPointMake(230.0f/PTM_RATIO, (FLOOR_HEIGHT+91.0f)/PTM_RATIO);
	//[self addChild:arm z:1];
	
	/*
	b2BodyDef armBodyDef;
	armBodyDef.type = b2_dynamicBody;
	armBodyDef.linearDamping = 1;
	armBodyDef.angularDamping = 1;
	armBodyDef.position.Set(330.0f/PTM_RATIO, (FLOOR_HEIGHT+61.0f)/PTM_RATIO);//230.0, 91.0
	//armBodyDef.userData = arm;
	armBody = world->CreateBody(&armBodyDef);
	
	b2PolygonShape armBox;
	b2FixtureDef armBoxDef;
	armBoxDef.shape = &armBox;
	armBoxDef.density = 0.3F;
	armBox.SetAsBox(2.0f/PTM_RATIO, 91.0f/PTM_RATIO);//11.0
	armFixture = armBody->CreateFixture(&armBoxDef);
	
	// Create a joint to fix the catapult to the floor
	b2RevoluteJointDef armJointDef;
	armJointDef.Initialize(groundBody, armBody, b2Vec2(233.0f/PTM_RATIO, FLOOR_HEIGHT/PTM_RATIO));
	armJointDef.enableMotor = true;
	armJointDef.enableLimit = true;
	armJointDef.motorSpeed = -10; //-1260
	armJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(9);
	armJointDef.upperAngle = CC_DEGREES_TO_RADIANS(75);
	armJointDef.maxMotorTorque = 700;//4800,700
	
	armJoint = (b2RevoluteJoint*)world->CreateJoint(&armJointDef);
	*/
	
	
	
	
	// ---- set up our fort and gun ----
	// character
	CCSprite *fortSprite = [CCSprite spriteWithFile:@"brs_split_char.png"];
	fortSprite.position = ccp(60.0f, FLOOR_HEIGHT);
	fortSprite.anchorPoint = ccp(0, 0);
	[self addChild:fortSprite z:0];
	[miscs addObject:fortSprite];
		
	// the gun
	MyCCSprite *gunSprite = [MyCCSprite spriteWithFile:@"brs_split_gun.png"];
	gunSprite.position = ccp(105.0f, FLOOR_HEIGHT + 45);
	gunSprite.anchorPoint = ccp(0, 0.5);
	gunSprite.rotation = -30;
	[self addChild:gunSprite z:9];
	[miscs addObject:gunSprite];
	
	b2BodyDef fortBodyDef;
	fortBodyDef.type = b2_dynamicBody;
	fortBodyDef.linearDamping = 1;
	fortBodyDef.angularDamping = 1;
	fortBodyDef.position.Set(105.0f/PTM_RATIO, (FLOOR_HEIGHT + 40.0)/PTM_RATIO);
	fortBodyDef.userData = gunSprite;
	fortBody = world->CreateBody(&fortBodyDef);
	b2CircleShape fortBox;
	b2FixtureDef fortBoxDef;
	fortBoxDef.isSensor = true;
	fortBoxDef.shape = &fortBox;
	fortBoxDef.density = 1.0f;
	fortBox.m_radius = 40.0f / PTM_RATIO;
	fortBody->CreateFixture(&fortBoxDef);
	//fortBody->SetTransform(fortBody->GetPosition(), CC_DEGREES_TO_RADIANS(30));
	
	b2RevoluteJointDef fortJointDef;
	fortJointDef.Initialize(groundBody, fortBody, b2Vec2(105.0f/PTM_RATIO, (FLOOR_HEIGHT + 40.0)/PTM_RATIO));
	fortJointDef.enableLimit = true;
	fortJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-30);
	fortJointDef.upperAngle = CC_DEGREES_TO_RADIANS(60);
	fortJoint = (b2RevoluteJoint*)world->CreateJoint(&fortJointDef);
	
	
	
}

- (void) createBarrier {
	[targets release];
	[enemies release];
	[miscs release];
	
	targets = [[NSMutableSet alloc] init];
	enemies = [[NSMutableSet alloc] init];
	miscs = [[NSMutableSet alloc] init];
	
	Barrier *barrier = [Barrier getBarrier:currentBarrier];
	
	[self createFort];	
	
	// Create the elements in barrier
	for (BarrierObject *object in barrier.elements) {
		if(object.type == BOT_Sprite) {
			CCSprite *sprite = [CCSprite spriteWithFile:object.texture];
			sprite.position = object.position;
			sprite.anchorPoint = object.anchor;
			[self addChild:sprite z:object.zindex];
			
			[miscs addObject:sprite];
		}else{
			[self createTarget:object];
			//[self createTarget:object.texture atPosition:object.position rotation:object.rotation isCircle:object.isCircle isStatic:object.isStatic isEnemy:object.isEnemy];
		}
	}
}


- (void) moveCamera:(CGPoint)transition withDuration:(NSInteger)duration {
	
	if (previewing) return;
	
	CGPoint target = ccp(self.position.x + transition.x, self.position.y - transition.y);
	
	if (duration == 0) {
		[self stopActionByTag:PomActionTagCamera];
		self.position = target;
	}else {
		ccTime duraInSec = duration / 1000.0f;
		CCMoveBy *moveBy = [CCMoveBy actionWithDuration:duraInSec position:target];
		moveBy.tag = PomActionTagCamera;
		[self runAction:moveBy];
	}
}

-(id) init
{
	if( (self=[super init])) {
		
		// init music
		[[SimpleAudioEngine sharedEngine] setEnabled:FALSE];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"bgm-test.caf"];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm-test.caf"];
		
		// enable events
		
		self.touchEnabled = YES;
		
		enableGravity = YES;
		
		cartridge = [[Cartridge alloc] init];
		
		// init physics
		[self initPhysics];
		
		currentBarrier = 2;
		
		// game start
		// At the end of the init method the catapult is still at the zero degree angle
		// so the bullet actually gets attached to the wrong position.
		//world->Step(0.5, 8, 1);
		//[self resetGame];
		//[self performSelector:@selector(resetGame) withObject:nil afterDelay:0.5f];
		
		//self.position = CGPointMake(-480, 0); // camera position
		
		// contact listener
		contactListener = new MyContactListener();
		world->SetContactListener(contactListener);
		
		[self scheduleUpdate];
	}
	return self;
}

- (void) onEnterTransitionDidFinish {
	[super onEnterTransitionDidFinish];
	
	// game start while layer loaded
	NSLog(@"-------Setting up game environment-------");
	[self resetGame];
	
	[self attachBullet];
}

- (BOOL) isPoint:(CGPoint&)point inBody:(b2Body*)body {
	if (body != nil) { // only response when tapped on the attached bullet
		CCNode *node = (CCNode*)body->GetUserData();
		
		CGPoint bulletPos;
		CGRect bulletRect;
		if (node) { // if CCNode available, pick it to compare
			bulletPos = node.position;
			CGPoint anchor = node.anchorPoint;
			bulletPos.x = bulletPos.x - (anchor.x - 0.5) * node.contentSize.width;
			bulletPos.y = bulletPos.y - (anchor.y - 0.5) * node.contentSize.height;
			/*
			bulletRect = CGRectMake(
					bulletPos.x - node.contentSize.width/2,
					bulletPos.y - node.contentSize.height/2,
					node.contentSize.width, node.contentSize.height);
			*/
			bulletRect = [node boundingBox];
		}else { // if CCNode unavailable, take phy point with a 40*40 box
			bulletPos = ccp(
					body->GetPosition().x * PTM_RATIO,
					body->GetPosition().y * PTM_RATIO);
			bulletRect = CGRectMake(bulletPos.x - 20.0f, bulletPos.y - 20.0f, 40.0f, 40.0f);
		}
		
		if(!CGRectContainsPoint(bulletRect, point)) {
			NSLog(@"not tapped in rect (%f,%f,%f,%f) (%f,%f)",
				  bulletRect.origin.x, bulletRect.origin.y,
				  bulletRect.size.width, bulletRect.size.height,
				  point.x, point.y);
		}else {
			return YES;
		}
	}
	
	return NO;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	//if(mouseJoint != nil) return;
	
	UITouch *myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView:[myTouch view]]; // where the touch occurs
	location = [[CCDirector sharedDirector] convertToGL:location];
	location = [self convertToNodeSpace:location];
	b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
	
	/*
	if(![self isPoint:location inBody:bulletBody]) {
		return;
	}
	
	if(locationWorld.x < armBody->GetWorldCenter().x + 50.0/PTM_RATIO) {		
		// When you set up a mouse joint, you have to give it two bodies.
		// The first isn't used, but the convention is to use the ground body.
		// The second is the body you want to move.
		b2MouseJointDef md;
		md.bodyA = groundBody;
		md.bodyB = armBody;
		md.target = locationWorld;
		md.maxForce = 2000;
		
		mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
	}
	*/
	
	// if mouseJoint existed, clear it
	if(mouseJoint != nil) {		
		world->DestroyJoint(mouseJoint);
		mouseJoint = nil;
	}
	
	// check whether inside fort body
	if(![self isPoint:location inBody:fortBody]) {
		return;
	}
	
	// When you set up a mouse joint, you have to give it two bodies.
	// The first isn't used, but the convention is to use the ground body.
	// The second is the body you want to move.
	b2MouseJointDef md;
	md.bodyA = groundBody;
	md.bodyB = fortBody;
	md.target = locationWorld;
	md.maxForce = 2000;
	
	mouseJoint = (b2MouseJoint *)world->CreateJoint(&md);
	
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if(mouseJoint != nil) {
		UITouch *myTouch = [touches anyObject];
		CGPoint location = [myTouch locationInView:[myTouch view]];
		location = [[CCDirector sharedDirector] convertToGL:location];
		location = [self convertToNodeSpace:location];
		//NSLog(@"mouse joint target: (%f, %f)", location.x, location.y);
		b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
		
		mouseJoint->SetTarget(locationWorld);
		
	}else {
		// pan, available only when bullet is locking
		if(bulletBody) {
			
			UITouch *myTouch = [touches anyObject];
			CGPoint location = [myTouch locationInView:[myTouch view]];
			CGPoint previous = [myTouch previousLocationInView:[myTouch view]];
			
			[self moveCamera:ccpSub(location, previous) withDuration:0];
		}
	}
	
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	/*
	if (mouseJoint != nil) {
		if (armJoint->GetJointAngle() >= CC_DEGREES_TO_RADIANS(10)) {//20
			releasingArm = YES;
		}
		
		world->DestroyJoint(mouseJoint);
		mouseJoint = nil;
	}
	*/
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	// preserve for fling operation
	
	//UITouch *myTouch = [touches anyObject];
	//[myTouch ]
	
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	self.hud = nil;
	
	[cartridge release];
	
	// release bullets
	[bullets release];
	
	[targets release];
	[enemies release];
	
	[miscs release];
	
	[super dealloc];
}	

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	if (enableGravity) {
		gravity.Set(0.0f, -10.0f);
	}else {
		gravity.SetZero();		
	}
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
	groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom, 4 times length
	groundBox.Set(b2Vec2(0, FLOOR_HEIGHT/PTM_RATIO), b2Vec2(s.width * 4.0f/PTM_RATIO, FLOOR_HEIGHT/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	//groundBox.Set(b2Vec2(0, s.height/PTM_RATIO), b2Vec2(s.width * 2.0f/PTM_RATIO, s.height/PTM_RATIO));
	//groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0, s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	//groundBox.Set(b2Vec2(s. width * 2.0f/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width*2.0f/PTM_RATIO,0));
	//groundBody->CreateFixture(&groundBox,0);
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
	// if reset detected, reset it
	if (self.hud.isRestart) {
		[self resetGame];
		[self.hud reset];
		[self.hud hideMenu];
		
		return;
	}else if(self.hud.isNext) {
		currentBarrier++;
		
		[self resetGame];
		[self.hud reset];
		[self.hud hideMenu];
		
		return;
	}
	
	
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
	
	// Arm is being released.
	/*
	if (releasingArm && bulletJoint) {
		
		if (armJoint->GetJointAngle() <= CC_DEGREES_TO_RADIANS(30)) { // 10
			
			// Check if the arm reached the end so we can return the limits
			releasingArm = NO;
			
			// Destroy joint so the bullet will be free
			world->DestroyJoint(bulletJoint);
			bulletJoint = nil;
			
			// try to add some effect
			MyCCSprite * node = (MyCCSprite *)bulletBody->GetUserData();
			[node createEffect];
			
			// reset combo counter
			combo = 0;
			
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			CCAction *camAction = [CCFollow actionWithTarget:(CCNode*)bulletBody->GetUserData()
											   worldBoundary:CGRectMake(0, 0, winSize.width*2, winSize.height)];
			camAction.tag = PomActionTagCamera;
			[self runAction:camAction];
			
			
			[self performSelector:@selector(resetBullet) withObject:nil afterDelay:5.0f];
		}
	}
	*/
	
	if (releasingArm) {
		releasingArm = NO;
		preservingFactor = 0;
		
		if (bulletBody) {
			
			// try to add some effect
			MyCCSprite * node = (MyCCSprite *)bulletBody->GetUserData();
			[node createEffect];
			
			// reset combo counter
			combo = 0;
			
			CGSize winSize = [[CCDirector sharedDirector] winSize];
			CCAction *camAction = [CCFollow actionWithTarget:(CCNode*)bulletBody->GetUserData()
											   worldBoundary:CGRectMake(0, 0, winSize.width*2, winSize.height)];
			camAction.tag = PomActionTagCamera;
			[self runAction:camAction];
			
			[self performSelector:@selector(resetBullet) withObject:nil afterDelay:3.0f];
			
			bulletBody = nil; // set bulletBody nil to unlock camera locking to it
		}
	}
	
	if(self.hud.isPreserving) {
		// TODO: increase power
		preservingFactor = (int)min(100, ++preservingFactor);
		NSLog(@"Preserving power factor to %d", preservingFactor);
		
		if (bulletBody) {			
			float32 angle = fortBody->GetAngle();
			b2Vec2 pos = fortBody->GetPosition();
			
			// i have defined fort with radius 40.0f above in createFort
			b2Vec2 bulletPos = b2Vec2(pos.x + 40.0f/PTM_RATIO * cos(angle), pos.y + 40.0f/PTM_RATIO * sin(angle));
			
			bulletBody->SetTransform(bulletPos, 0);
			
			// test particle system, i should place it to bullet class
			if(preservingFactor == 1) {				
				CCParticleSun *assembleEffect = [[CCParticleSun alloc] initWithTotalParticles:1000];
				assembleEffect.emissionRate=500.0f; // i added it for a faster emission
				assembleEffect.autoRemoveOnFinish = YES;
				assembleEffect.startSize = 20.0f;
				assembleEffect.speed = 40.0f;
				assembleEffect.anchorPoint = ccp(0.5f, 0.5f);
				assembleEffect.duration = 5;
				assembleEffect.position = ccp(bulletPos.x * PTM_RATIO, bulletPos.y * PTM_RATIO);
				assembleEffect.gravity = ccp(-80, 0);
				assembleEffect.positionType = kCCPositionTypeRelative;
				assembleEffect.emitterMode = kCCParticleModeGravity;
				[self addChild:assembleEffect];
			}
			
		}
		
	}else if(self.hud.isEjecting) {
		self.hud.isEjecting = NO;
		
		float32 angle = fortBody->GetAngle();
		b2Vec2 pos = fortBody->GetPosition();
		
		NSLog(@"Eject at (%f, %f) with angle (%f)", pos.x * PTM_RATIO, pos.y * PTM_RATIO, CC_RADIANS_TO_DEGREES(angle));
		
		// TODO: set position of bullet and give a impulse
		if (bulletBody) {
			releasingArm = YES;
			bulletBody->SetActive(true);
			
			// i have defined fort with radius 40.0f above in createFort
			b2Vec2 bulletPos = b2Vec2(pos.x + 40.0f/PTM_RATIO * cos(angle), pos.y + 40.0f/PTM_RATIO * sin(angle));
			
			bulletBody->SetTransform(bulletPos, 0);
			
			float power = preservingFactor / 2.0f;
			b2Vec2 impulse = b2Vec2(power * cos(angle), power * sin(angle));
			bulletBody->ApplyLinearImpulse(impulse, bulletBody->GetPosition());
		}
		
	}
	
	// always bounding the viewable rect
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	self.position = ccp(MIN(MAX(-screenSize.width, self.position.x), 0), 0);
	
	
	// Check for impacts
	std::vector<MyContact>::iterator pos;
	std::set<b2Body*> toDestroy;
	for (pos=contactListener->contacts.begin(); pos!=contactListener->contacts.end(); ++pos) {
		MyContact myContact = *pos;
		float32 impulse = myContact.maxImpulse;
		
		NSLog(@"myContact.maxImpulse=%f", impulse);
		
		b2Body *bodyA = myContact.fixtureA->GetBody();
		b2Body *bodyB = myContact.fixtureB->GetBody();
		
		[self strikeBody:bodyA withImpulse:impulse toDestroy:toDestroy];
		[self strikeBody:bodyB withImpulse:impulse toDestroy:toDestroy];
	}
	
	std::set<b2Body*>::iterator pos2;
	for (pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
		b2Body *body = *pos2;
		
		CCNode *node = (CCNode *)body->GetUserData();
		
		// display explosion effect
		if ([node isKindOfClass:[MyCCSprite class]]) {
			[(MyCCSprite *)node createAffterEffect];
		}
		
		// let's remove it
		[self removeChild:node cleanup:YES];
		world->DestroyBody(body);
		
		[targets removeObject:[NSValue valueWithPointer:body]];
		[enemies removeObject:[NSValue valueWithPointer:body]];
		
		// calculate the score
		BarrierObject *bo = (BarrierObject *)node.userData;
		if (bo && bo.type == BOT_Enemy) {
			score += 10 + (combo++) * 5;
		}else {
			score += 2 + (combo++) * 1;
		}
		[self.hud updateScore:score];
	}
	
	// remove everything from the set
	contactListener->contacts.clear();
	
}

- (void) strikeBody:(b2Body*)body withImpulse:(float32)impulse toDestroy:(std::set<b2Body*> &)toDestroy {
	
	CCNode *node = (CCNode *)body->GetUserData();
	if (node && node.userData) { // BarrierObject stored in node.userData
		BarrierObject *bo = (BarrierObject *)node.userData;
		BarrierObjectType type = bo.type;
		BOOL isViolable = bo.isViolable;
		
		if(isViolable) {
			int damage = MIN(MAX(0, (int)impulse), 5);
			bo.life -= damage;
			
			if(bo.life <= 0) {
				toDestroy.insert(body);
				
			}else if(type == BOT_Block) {
				// display wearout effect
				float percentage = bo.life / bo.maxlife;
				if (percentage < 0.8f && [node isKindOfClass:[MyCCSprite class]]) {
					[(MyCCSprite *)node enableMaskEffect];
				}
			}
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
