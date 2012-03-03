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
    NSString *attribute;
}

@property (readonly) CCSprite *sprite;
@property (readonly) BOOL receivedTouch;
@property (readwrite,assign) BOOL canReceiveTouch;
@property (readwrite,assign) int cardIndex;
@property (readonly) BOOL onDeck;
@property (readonly) NSString *attribute;

+(id) cardWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index withAttribute:(NSString *)attribute_ ;
-(id) initWithParentNode:(CCNode *)parentNode withCard:(NSString *)card withIndex:(int)index withAttribute:(NSString *)attribute_ ;
-(void) reset;
@end
