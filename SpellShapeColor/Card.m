//
//  Card.m
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "GameLayer.h"

@interface Card (PrivateMethods)
-(void) moveToDeck;
@end

@implementation Card

@synthesize sprite;
@synthesize receivedTouch;
@synthesize cardIndex;
@synthesize canReceiveTouch;
@synthesize onDeck;

+(id) cardWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index {
    return [[[self alloc] initWithParentNode:parentNode withCard:card withIndex:index] autorelease];
}

-(id) initWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [parentNode addChild:self];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES]; 
        
        sprite = [CCSprite spriteWithFile:card];
        [self addChild:sprite z:0];
        
        cardIndex = index;
        onDeck = NO;
        receivedTouch = NO;
        canReceiveTouch = NO;
    }
    
    return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (canReceiveTouch && CGRectContainsPoint([sprite boundingBox], [GameLayer locationFromTouch:touch]) && !onDeck) {
        receivedTouch = YES;
        [self moveToDeck];
    }
    
    return NO;
}

-(void) moveToDeck {
    CGSize winSize = [[CCDirector sharedDirector] winSize];    
    int indexOffset = (([sprite texture].contentSize.height/2) * cardIndex) + ([sprite texture].contentSize.height/2 * cardIndex);
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.4f position:ccp(35, winSize.height - indexOffset)];
    CCFadeTo *fade = [CCFadeTo actionWithDuration:1.0f opacity:75.0f];
    CCSequence *seq = [CCSequence actions:move, fade, nil];
    
    [sprite runAction:seq];
    
    onDeck = YES;
}

-(void) dealloc {
    [super dealloc];
}

@end
