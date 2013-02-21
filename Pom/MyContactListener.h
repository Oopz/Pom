//
//  MyContactListener.h
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#ifndef __Pom__MyContactListener__
#define __Pom__MyContactListener__

#include <iostream>

#endif /* defined(__Pom__MyContactListener__) */


#import "Box2D.h"
#import <set>
#import <algorithm>

class MyContactListener : public b2ContactListener {
	
public:
	std::set<b2Body*>contacts;
	
	MyContactListener();
	~MyContactListener();
	
	virtual void BeginContact(b2Contact* contact);
	virtual void EndContact(b2Contact* contact);
	virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	
	
};








