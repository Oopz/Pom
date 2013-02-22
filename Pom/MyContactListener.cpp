//
//  MyContactListener.cpp
//  Pom
//
//  Created by Bill on 21/2/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#include "MyContactListener.h"


MyContactListener::MyContactListener() : contacts() {
	
}

MyContactListener::~MyContactListener() {
	
}

void MyContactListener::BeginContact(b2Contact *contact) {
	
}

void MyContactListener::EndContact(b2Contact *contact) {
	
}

void MyContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
	
}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
	bool isAEnemy = contact->GetFixtureA()->GetUserData() != NULL;
	bool isBEnemy = contact->GetFixtureB()->GetUserData() != NULL;
	if (isAEnemy || isBEnemy) {
		// Should the body break?
		int32 count = contact->GetManifold()->pointCount;
		
		float32 maxImpulse = 0.0f;
		for (int32 i = 0; i<count; ++i) {
			maxImpulse = b2Max(maxImpulse, impulse->normalImpulses[i]);
		}
		
		float stamina = 0.5f;//1.0f
		
		if (maxImpulse > stamina) {
			// Flag the enemy(ies) for breaking.
			if(isAEnemy)
				contacts.insert(contact->GetFixtureA()->GetBody());
			if(isBEnemy)
				contacts.insert(contact->GetFixtureB()->GetBody());
		}
	}
}




