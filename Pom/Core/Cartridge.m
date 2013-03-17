//
//  Cartridge.m
//  Pom
//
//  Created by Bill on 18/3/13.
//  Copyright (c) 2013 Oopz. All rights reserved.
//

#import "Cartridge.h"
#import "BarrierObject.h"

@implementation Cartridge

@synthesize objects;

- (id)init
{
    self = [super init];
    if (self) {
		self.objects = [[NSMutableArray alloc] initWithCapacity:4];
		
        for (int i=0; i<4; i++) {
			BarrierObject *bullet = [[[BarrierObject alloc] initAsBullet:@"acorn.png"] autorelease];
			//bullet.life = 20;
			[self.objects addObject:bullet];
		}
    }
    return self;
}

- (void)dealloc {
	[self.objects release];
	
	[super dealloc];
}

@end
