//
//  GameLayer.m
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "Shape.h"
#import "HUDLayer.h"
#import "CArd.h"

static GameLayer *gameLayerInstance;

// GameLayer implementation
@implementation GameLayer


+(GameLayer *) sharedLayer {
    NSAssert(gameLayerInstance != nil, @"GameLayer not available!");
    return gameLayerInstance;
}

-(GameLayer *)gameLayer {
    CCNode *layer = [self getChildByTag:101];
    
    NSAssert([layer isKindOfClass:[GameLayer class]], @"%@: not a GameLayer!", NSStringFromSelector(_cmd));
    
    return (GameLayer *)layer;
}

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	
	return scene;
}

+(CGPoint) locationFromTouch:(UITouch*)touch {
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(id) init {
	if ((self = [super init])) {        
		NSAssert(gameLayerInstance == nil, @"Another GameLayer is already in use!");
		gameLayerInstance = self;
        
        Shape *square1 = [Shape shapeWithParentNode:self withShape:@"square" withColor:@"green"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [square1 sprite].position = ccp(winSize.width/2,winSize.height - ([[square1 sprite] texture].contentSize.height/2));
        CCMoveTo *move = [CCMoveTo actionWithDuration:10.0f position:ccp(winSize.width/2,([[square1 sprite] texture].contentSize.height/2))];
        [[square1 sprite] runAction:move];
        square1.tag = 200;
        
        spellHud = [HUDLayer hudWithParentNode:self withIndex:1];
        shapeHud = [HUDLayer hudWithParentNode:self withIndex:2];
        colorHud = [HUDLayer hudWithParentNode:self withIndex:3];
        
        [spellHud sprite].position = ccp(([[spellHud sprite] texture].contentSize.width/2) + 5, ([[spellHud sprite] texture].contentSize.height/2) + 130);
        [shapeHud sprite].position = ccp(([[shapeHud sprite] texture].contentSize.width/2) + 5, ([[shapeHud sprite] texture].contentSize.height/2) + 90);
        [colorHud sprite].position = ccp(([[colorHud sprite] texture].contentSize.width/2) + 5, ([[colorHud sprite] texture].contentSize.height/2) + 50);
        
        Card *fireCard = [Card cardWithParentNode:self withCard:@"spell_fire.png" withIndex:1];
        Card *iceCard = [Card cardWithParentNode:self withCard:@"spell_ice.png" withIndex:2];   
        Card *stoneCard = [Card cardWithParentNode:self withCard:@"spell_stone.png" withIndex:3];
        
        Card *fireCard2 = [Card cardWithParentNode:self withCard:@"spell_fire.png" withIndex:1];
        Card *iceCard2 = [Card cardWithParentNode:self withCard:@"spell_ice.png" withIndex:2];   
        Card *stoneCard2 = [Card cardWithParentNode:self withCard:@"spell_stone.png" withIndex:3];
        
        Card *fireCard3 = [Card cardWithParentNode:self withCard:@"spell_fire.png" withIndex:1];
        Card *iceCard3 = [Card cardWithParentNode:self withCard:@"spell_ice.png" withIndex:2];   
        Card *stoneCard3 = [Card cardWithParentNode:self withCard:@"spell_stone.png" withIndex:3];        
        
        [spellHud addCard:fireCard];
        [spellHud addCard:iceCard];
        [spellHud addCard:stoneCard];  
        
        [shapeHud addCard:fireCard2];
        [shapeHud addCard:iceCard2];
        [shapeHud addCard:stoneCard2];  
        
        [colorHud addCard:fireCard3];
        [colorHud addCard:iceCard3];
        [colorHud addCard:stoneCard3];   
        
        [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosao.plist"];
        
        [self scheduleUpdate];
	}
    
	return self;
}

-(void) update:(ccTime)delta {
    if ([spellHud cardPicked] != nil && [shapeHud cardPicked] != nil && [colorHud cardPicked] != nil
        && [spellHud cardPicked].onDeck && [shapeHud cardPicked].onDeck && [colorHud cardPicked].onDeck) {
        Shape *square = (Shape *)[self getChildByTag:200];
        CCParticleSystem *system = [CCParticleSystemQuad particleWithFile:@"explosao.plist"];
        system.position = [square sprite].position;
        square.visible = NO;        
        [self addChild:system z:1];

        
        [spellHud reset];
        [shapeHud reset];
        [colorHud reset];
    }
}

-(void) loadShapes {
    
}

- (void) dealloc
{
    gameLayerInstance = nil;
	[super dealloc];
}
@end
