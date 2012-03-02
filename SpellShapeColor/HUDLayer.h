//
//  HUDLayer.h
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"

@interface HUDLayer : CCNode <CCTargetedTouchDelegate> {
    NSMutableArray *cards;
    CCSprite *sprite;
    BOOL cardsDisplayed;
    Card *cardPicked;
    int hudIndex;
}

@property (readonly) NSMutableArray *cards;
@property (readonly) CCSprite *sprite;
@property (readwrite, assign) int hudIndex;
@property (readonly) Card *cardPicked;

+(id) hudWithParentNode:(CCNode *)parentNode withIndex:(int)index;
-(id) initWithParentNode:(CCNode *)parentNode withIndex:(int)index;
-(void) addCard:(Card *)card;
-(void) reset;

@end


