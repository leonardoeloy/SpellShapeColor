//
//  Shape.h
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define SQUARE  "square"
#define CIRCLE  "circle"

#define BLUE    "blue"
#define GREEN   "green"
#define YELLOW  "yellow"

@interface Shape : CCNode {
    CCSprite *sprite;
    NSString *shape, *color;
}

@property (readonly) CCSprite *sprite;
@property (readonly) NSString *shape;
@property (readonly) NSString *color;


+(id) shapeWithParentNode:(CCNode *)parentNode withShape:(NSString *)shape_ withColor:(NSString *)color_ ;
-(id) initWithParentNode:(CCNode *)parentNode withShape:(NSString *)shape_ withColor:(NSString *)color_;

@end
