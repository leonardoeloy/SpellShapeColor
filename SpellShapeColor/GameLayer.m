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

@interface GameLayer (PrivateMethods)
-(void) loadLevel;
@end

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
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];       
        
        Card *fireCard = [Card cardWithParentNode:self withCard:@"spell_fire.png" withIndex:1 withAttribute:@"explosao.plist"];
        Card *iceCard = [Card cardWithParentNode:self withCard:@"spell_ice.png" withIndex:1 withAttribute:@"ice-particles.plist"];   
        //Card *stoneCard = [Card cardWithParentNode:self withCard:@"spell_stone.png" withIndex:3];
        
        Card *squareCard = [Card cardWithParentNode:self withCard:@"shape_square.png" withIndex:2 withAttribute:@"square"];
        Card *circleCard = [Card cardWithParentNode:self withCard:@"shape_circle.png" withIndex:2 withAttribute:@"circle"];   
        
        Card *yellowCard = [Card cardWithParentNode:self withCard:@"color_yellow.png" withIndex:3 withAttribute:@"yellow"];
        Card *blueCard = [Card cardWithParentNode:self withCard:@"color_blue.png" withIndex:3 withAttribute:@"blue"];   
        Card *greenCard = [Card cardWithParentNode:self withCard:@"color_green.png" withIndex:3 withAttribute:@"green"];        
                
        spellHud = [HUDLayer hudWithParentNode:self withIndex:1];
        shapeHud = [HUDLayer hudWithParentNode:self withIndex:2];
        colorHud = [HUDLayer hudWithParentNode:self withIndex:3];
        
        [spellHud addCard:fireCard];
        [spellHud sprite].position = ccp([[fireCard sprite] texture].contentSize.width/2 + 15, [[fireCard sprite] texture].contentSize.height/2 + 5);        
        [spellHud addCard:iceCard];
        
        [shapeHud addCard:squareCard];
        [shapeHud sprite].position = ccp(([[shapeHud sprite] texture].contentSize.width/2) + 5, ([[shapeHud sprite] texture].contentSize.height/2) + 90);        
        [shapeHud addCard:circleCard]; 
        
        [colorHud addCard:yellowCard];
        [colorHud sprite].position = ccp(([[colorHud sprite] texture].contentSize.width/2) + 5, ([[colorHud sprite] texture].contentSize.height/2) + 50);         
        [colorHud addCard:blueCard];
        [colorHud addCard:greenCard];   
        
        [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"explosao.plist"];
        [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"ice-particles.plist"];     
        
        [self loadLevel];
        
        [self scheduleUpdate];
	}
    
	return self;
}

-(void) update:(ccTime)delta {
    if ([spellHud cardPicked] != nil && [shapeHud cardPicked] != nil && [colorHud cardPicked] != nil
        && [spellHud cardPicked].onDeck && [shapeHud cardPicked].onDeck && [colorHud cardPicked].onDeck) {
        NSEnumerator *enumerator = [shapes objectEnumerator];
        Shape *shape;
        NSString *particleFile = [spellHud cardPicked].attribute;
        NSString *selectedShape = [shapeHud cardPicked].attribute;
        NSString *selectedColor = [colorHud cardPicked].attribute;
        
        while (shape = (Shape *)[enumerator nextObject]) {
            if ([selectedShape isEqualToString:shape.shape] && [selectedColor isEqualToString:shape.color]) {
                CCParticleSystem *system = [CCParticleSystemQuad particleWithFile:particleFile];
                system.position = [shape sprite].position; 
                [self addChild:system z:1];               
                
                if ([particleFile isEqualToString:@"explosao.plist"]) {
                    shape.visible = NO;       
                } else {
                    [[shape sprite] stopAllActions];
                }
            }                                                    
        }
            
        [spellHud reset];
        [shapeHud reset];
        [colorHud reset];
    }
}

-(void) loadLevel {
    NSString *level = @"Sg;  ;Cy;Sy;Sb";
    NSArray *levelShapes = [level componentsSeparatedByString:@";"];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    shapes = [[NSMutableArray alloc] init];
    
    for (NSString *strShape in levelShapes) {
        NSString *shapeType = nil;
        NSString *colorType = nil;
        
        // Obter o formato
        switch ([strShape characterAtIndex:0]) {
            case 'S': shapeType = @"square"; break;
            case 'C': shapeType = @"circle"; break;
            default: CCLOG(@"Shape '%c' not recognized", [strShape characterAtIndex:0]);
        }
        
        // Obter o formato
        switch ([strShape characterAtIndex:1]) {
            case 'g': colorType = @"green"; break;
            case 'b': colorType = @"blue"; break;
            case 'y': colorType = @"yellow"; break;                
            default: CCLOG(@"Color '%c' not recognized", [strShape characterAtIndex:1]);
        }
        
        if (shapeType == nil || colorType == nil) {
            CCLOG(@"Couldn't draw shape!");
            continue;
        }
        
        Shape *shape = [Shape shapeWithParentNode:self withShape:shapeType withColor:colorType];
        int position = [levelShapes indexOfObject:strShape];
        int indexOffset = [[shape sprite] texture].contentSize.width/2 + (65 * position);
        [shape sprite].position = ccp(indexOffset, winSize.height - ([[shape sprite] texture].contentSize.height/2));
        CCMoveTo *move = [CCMoveTo actionWithDuration:20.0f position:ccp(indexOffset,([[shape sprite] texture].contentSize.height/2))];
        [[shape sprite] runAction:move];
        
        [shapes addObject:shape];
    }   
}

- (void) dealloc
{
    gameLayerInstance = nil;
    [shapes release];
    
	[super dealloc];
}
@end
