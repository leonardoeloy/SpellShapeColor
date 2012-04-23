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
        
        sprite = [CCSprite spriteWithFile:@"hud_button2.png"];
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
        BOOL hud = CGRectContainsPoint([sprite boundingBox], [GameLayer locationFromTouch:touch]);
        CCLOG(@"%i: hud=%i cards=%i", hudIndex, (int)hud, (int)cardsDisplayed);
        
        if (hud && !cardsDisplayed) {
            [self displayCards];
        } else if (cardsDisplayed) {
            [self hideCards];
        }
    }
    
    return NO;
}

-(void) displayCards {
    CCLOG(@"Display cards on %i", hudIndex);
    // Começar pequeno no centro do HUD
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    NSEnumerator *enumerator = [cards objectEnumerator];
    Card *card;
    
    while (card = (Card *)[enumerator nextObject]) {
        [card sprite].position = sprite.position;
        [card sprite].scale = 0.1f;
        float cardPositionOffset = (float)[cards indexOfObject:card]/10;
        int cardIndex = [cards indexOfObject:card]+1;
        
        // Mover para a primeira posição do deck
        int x = (winSize.width/8) * cardIndex + (winSize.width/10) * cardIndex;
        CGPoint destino = ccp([card sprite].position.x + x, [card sprite].position.y);
        CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.2f+cardPositionOffset position:destino];
        
        // Chamar onCardReady
        CCCallFuncO *call = [CCCallFuncO actionWithTarget:self selector:@selector(onCardDisplayed:) object:(id)card];
        CCDelayTime *delay = [CCDelayTime actionWithDuration:0.2+cardPositionOffset];
        CCSequence *seq = [CCSequence actions:delay, call, nil];
        
        // Aumentar o tamanho
        CCAction *scaleAction = [CCScaleTo actionWithDuration:0.2f+cardPositionOffset scale:1.0f];
        
        // Gotta figure out why this opacity doesn't work properly if you set it to 100.0f
        [card sprite].opacity = 200.0f;
        [card sprite].visible = YES;
        
        [[card sprite] runAction:scaleAction];
        [[card sprite] runAction:moveAction];
        [[card sprite] runAction:seq];
    }
    
    cardsDisplayed = YES; 
}

-(void) hideCards {
    CCLOG(@"Hide cards on %i", hudIndex);
    NSEnumerator *enumerator = [cards objectEnumerator];
    Card *card;
    
    while (card = (Card *)[enumerator nextObject]) {
        card.canReceiveTouch = NO;        
        
        // Caso a carta tenha recebido o toque, ignorar, pois ela será animada para o deck
        if (card.receivedTouch) {
            cardPicked = card;
            continue;
        }
        
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
    [card reset];
}

-(void) onCardDisplayed:(id)obj {
    Card *card = (Card *)obj;
    card.canReceiveTouch = YES;
}

-(void) reset {
    CCLOG(@"Reset cards on %i", hudIndex);
    NSAssert(cardPicked != nil, @"Card must be picked for HUD to be reseted!");
    
    // Animar carta selecionada de volta para o HUD
    CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.2f position:sprite.position];
    CCAction *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:0.1f];
    
    // Remover o sprite depois de tudo
    CCCallFuncO *call = [CCCallFuncO actionWithTarget:self selector:@selector(onCardHidden:) object:(id)cardPicked];
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.2f];
    CCFadeTo *fadeAction = [CCFadeTo actionWithDuration:1.0f opacity:0.0f];
    CCSequence *seq = [CCSequence actions:delay, call, nil];
    
    [[cardPicked sprite] runAction:scaleAction];
    [[cardPicked sprite] runAction:moveAction];
    [[cardPicked sprite] runAction:fadeAction];
    [[cardPicked sprite] runAction:seq];
    
    cardPicked = nil;
    cardsDisplayed = NO;
    
    for (Card *card in cards) {
        if (!card.receivedTouch) {
            [card reset];
        }
    }
}

-(void) dealloc {
    [cards release];
    sprite = nil;
    cardPicked = nil;
    
    [super dealloc];
}

@end
