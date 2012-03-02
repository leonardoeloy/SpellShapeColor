//
//  GameLayer.h
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "cocos2d.h"
#import "HUDLayer.h"

@interface GameLayer : CCLayer
{
    HUDLayer *spellHud;
    HUDLayer *shapeHud;
    HUDLayer *colorHud;    
    
}

+(CCScene *) scene;
+(GameLayer *) sharedLayer;
+(CGPoint) locationFromTouch:(UITouch*)touch;

@end
