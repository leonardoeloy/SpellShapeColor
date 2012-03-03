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
@synthesize attribute;

+(id) cardWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index withAttribute:(NSString *)attribute_ {
    return [[[self alloc] initWithParentNode:parentNode withCard:card withIndex:index withAttribute:attribute_] autorelease];
}

-(id) initWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index withAttribute:(NSString *)attribute_ {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [parentNode addChild:self z:2];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES]; 
        
        sprite = [CCSprite spriteWithFile:card];
        attribute = attribute_;
        cardIndex = index;
        [self addChild:sprite z:0];
        
        [self reset];
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
    int indexOffset = (([sprite texture].contentSize.height/2) * cardIndex)*2;
    CCMoveTo *move = [CCMoveTo actionWithDuration:0.4f position:ccp(35, winSize.height - indexOffset)];
    CCFadeTo *fade = [CCFadeTo actionWithDuration:1.0f opacity:75.0f];
    CCSequence *seq = [CCSequence actions:move, fade, nil];
    
    [sprite runAction:seq];
    
    onDeck = YES;
}

-(void) reset {
    onDeck = NO;
    receivedTouch = NO;
    canReceiveTouch = NO;
    sprite.visible = NO;
    sprite.opacity = 200.0f;    
}

-(void) dealloc {
    [super dealloc];
}

@end
