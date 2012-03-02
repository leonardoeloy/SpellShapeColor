//
//  Shape.m
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Shape.h"

@interface Shape (PrivateMethods)
-(void) loadSpriteWithShape:(NSString *)shape_ withColor:(NSString *)color_;
@end

@implementation Shape

@synthesize sprite;
@synthesize shape;
@synthesize color;

+(id) shapeWithParentNode:(CCNode *)parentNode withShape:(NSString *)shape_ withColor:(NSString *)color_ {
    return [[[self alloc] initWithParentNode:parentNode withShape:shape_ withColor:color_] autorelease];
}


-(id) initWithParentNode:(CCNode *)parentNode withShape:(NSString *)shape_ withColor:(NSString *)color_ {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [parentNode addChild:self];
        
        [self loadSpriteWithShape:shape_ withColor:color_];  
        
        [self addChild:sprite];
    }
    
    return self;
}

-(void) loadSpriteWithShape:(NSString *)shape_ withColor:(NSString *)color_  {
    shape = shape_;
    color = color_;
    
    sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@.png", shape, color]];
}

-(void) dealloc {
    [super dealloc];
}

@end