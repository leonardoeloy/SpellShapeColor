//
//  Card.h
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Card : CCNode <CCTargetedTouchDelegate>  {
    CCSprite *sprite;
    BOOL onDeck;
    BOOL receivedTouch;
    BOOL canReceiveTouch;
    int cardIndex;
}

@property (readonly) CCSprite *sprite;
@property (readonly) BOOL receivedTouch;
@property (readwrite,assign) BOOL canReceiveTouch;
@property (readwrite,assign) int cardIndex;
@property (readonly) BOOL onDeck;

+(id) cardWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index;
-(id) initWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index;
    
@end
