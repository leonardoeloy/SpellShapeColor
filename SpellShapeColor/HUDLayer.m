//
//  HUDLayer.m
//  SpellShapeColor
//
//  Created by Leonardo Eloy on 01/03/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"
#import "GameLayer.h"
#import "Card.h"

@interface HUDLayer (PrivateMethods)
-(void) displayCards;
-(void) hideCards;
-(void) removerCard:(id)sender;
@end

@implementation HUDLayer

@synthesize sprite;
@synthesize cards;
@synthesize hudIndex;
@synthesize cardPicked;

+(id) hudWithParentNode:(CCNode *)parentNode withIndex:(int)index {
   return [[[self alloc] initWithParentNode:parentNode withIndex:index] autorelease];
}

-(id) initWithParentNode:(CCNode *)parentNode withIndex:(int)index {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES]; 
        
        [parentNode addChild:self z:2];
        
        sprite = [CCSprite spriteWithFile:@"hud_button.png"];
        cardsDisplayed = NO;
        cardPicked = nil;
        hudIndex = index;
        
        cards = [[NSMutableArray alloc] init];
        
        [self addChild:sprite];
    }
    
    return self;
}

-(void) addCard:(Card *)card {
    [cards addObject:card];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (cardPicked == nil) {
        if (CGRectContainsPoint([sprite boundingBox], [GameLayer locationFromTouch:touch]) && !cardsDisplayed) {
            [self displayCards];
        } else if (cardsDisplayed) {
            [self hideCards];
        }
    }
    
    return NO;
}

-(void) displayCards {
    // Começar pequeno no centro do HUD
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSEnumerator *enumerator = [cards objectEnumerator];
    Card *card;
    
    while (card = (Card *)[enumerator nextObject]) {
        [card sprite].position = sprite.position;
        [card sprite].scale = 0.1f;
        
        // Mover para a primeira posição do deck
        int indexOffset = (winSize.width/8) * card.cardIndex + (winSize.width/10) * card.cardIndex;
        CGPoint destino = ccp([card sprite].position.x + indexOffset, [card sprite].position.y);
        CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.2f position:destino];
        
        // Chamar onCardReady
        CCCallFuncO *call = [CCCallFuncO actionWithTarget:self selector:@selector(onCardDisplayed:) object:(id)card];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.2f];
        CCSequence *seq = [CCSequence actions:delay, call, nil];
        
        // Aumentar o tamanho
        CCAction *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:1.0f];
        
        [card sprite].visible = true;
        
        [[card sprite] runAction:scaleAction];
        [[card sprite] runAction:moveAction];
        [[card sprite] runAction:seq];
    }
    
    cardsDisplayed = YES; 
}

-(void) hideCards {
    NSEnumerator *enumerator = [cards objectEnumerator];
    Card *card;
    
    while (card = (Card *)[enumerator nextObject]) {
        // Caso a carta tenha recebido o toque, ignorar, pois ela será animada para o deck
        if (card.receivedTouch) {
            cardPicked = card;
            continue;
        }
        
        card.canReceiveTouch = NO;        
        
        CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.2f position:sprite.position];
        CCAction *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:0.1f];
        CCFadeTo *fadeAction = [CCFadeTo actionWithDuration:1.0f opacity:100.0f];
        
        // Remover o sprite depois de tudo
        CCCallFuncO *call = [CCCallFuncO actionWithTarget:self selector:@selector(onCardHidden:) object:(id)card];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.2f];
        CCSequence *seq = [CCSequence actions:delay, call, nil];
        
        [[card sprite] runAction:scaleAction];
        [[card sprite] runAction:moveAction];
        [[card sprite] runAction:fadeAction];        
        [[card sprite] runAction:seq];
    }
    
    cardsDisplayed = NO;
}

-(void) onCardHidden:(id)obj {
    Card *card = (Card *)obj;
    [card sprite].visible = false;
}

-(void) onCardDisplayed:(id)obj {
    Card *card = (Card *)obj;
    card.canReceiveTouch = YES;
    //[card sprite].opacity = 100.0f;
}

-(void) reset {
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.2f position:sprite.position];
    CCAction *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:0.1f];
    
    // Remover o sprite depois de tudo
    CCCallFuncO *call = [CCCallFuncO actionWithTarget:self selector:@selector(onCardHidden:) object:(id)cardPicked];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.2f];
    CCSequence *seq = [CCSequence actions:delay, call, nil];
    
    [[cardPicked sprite] runAction:scaleAction];
    [[cardPicked sprite] runAction:moveAction];
    [[cardPicked sprite] runAction:seq];
    
    cardPicked = nil;
    cardsDisplayed = NO;
}

-(void) dealloc {
    [cards release];
    
    [super dealloc];
}

@end
