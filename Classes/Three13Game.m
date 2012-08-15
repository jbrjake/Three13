//
//  Three13Game.m
//  313-prototype
//
//  Created by Jonathon Rubin on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three13Game.h"


@implementation Three13Game

@synthesize deck, hand, mysteryCard, knownCard, state, level, round, currentScore, totalScore, delegate;

-(id) init  {
    if( self = [super init] ) {
        deck = [[Three13Deck alloc] init];
        hand = [[Three13Hand alloc] init];
        knownCard = [[Three13Card alloc] init];
        mysteryCard = [[Three13Card alloc] init];
        state = -1;
        level = 3;
        round = 1;
        totalScore = 0;
        currentScore = 0;
        global_queue = dispatch_get_global_queue(0, 0);
    }
    return self;
}

#pragma mark Internal methods

-(void) deal: (NSInteger) cardNumber {
    if (level > 13 ) {
        NSLog(@"Game over!");
        return;
    }
    [deck shuffle];
    [hand.cards removeAllObjects];
    for( int i = 0; i < cardNumber; i++ ) {
        [hand addCard: [deck draw]];
    }
    [hand sortBySuit];
    [hand sortByValue];
    knownCard = [deck draw];
    //    NSLog(@"Set known card to %@", knownCard);
    mysteryCard = [deck draw];
    //    NSLog(@"Set mystery card to %@", mysteryCard);
    [hand updateScore];
    [self setCurrentScore:hand.score];
}

-(void) checkForWin {
    //First check for going out
    //Then check for out of time
    
    [hand updateScore];
    [self setCurrentScore:hand.score];
    if (hand.score == 0) {
        //        NSLog(@"It's a win!");
        [self endLevel];
    }
    else if( round > level-1 ) {
        //       NSLog(@"Out of rounds!");
        [self setTotalScore:totalScore + hand.score];
        [self endLevel];
    }
    else {
        //        NSLog(@"Dealing new mystery/known cards");
        // Deal new mystery/known cards
        knownCard = [deck draw];
        mysteryCard = [deck draw];
        [self setRound:round+1];
        if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
            [delegate respondToStartOfRoundWithDictionary:[self gameDict]];
        }
        else {
            // Fall back on loose coupling
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Round" object:self userInfo:[self gameDict] ];
        }
    }
    
}

-(NSMutableDictionary *) gameDict {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: [hand cardIDs], @"hand", [deck cardIDs], @"deck", @(knownCard.number), @"known", @(mysteryCard.number), @"mystery", @0, @"discard", nil ];
    return dict;
}

-(NSMutableArray *) allCards {
    NSMutableArray * returnArray = [[NSMutableArray alloc] init];
    [returnArray addObjectsFromArray:deck.cards];
    [returnArray addObjectsFromArray:hand.cards];
    [returnArray addObject:mysteryCard];
    [returnArray addObject:knownCard];
    return returnArray;
}

#pragma mark Three13ViewDataSource protocol implementation

-(void) startGame {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted) name:@"Started Game" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDiscarded) name:@"Discarded Card" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelEnded) name:@"Ended Level" object:nil];

    [self deal:level];
    [hand updateScore];
//    NSLog(@"Known and unkonw are %@ and %@", knownCard, mysteryCard);
    [self setState:0];
//    NSLog(@"Start Game completed");
//  [self testGame];
    
    if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
        [delegate respondToStartOfGameWithCompletionHandler:^ {
            dispatch_async(global_queue, ^{
                [self gameStarted];
            });
        }];
    }
    else {
        // Fall back on loose coupling
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Game" object:self userInfo:[self gameDict] ];
    }
}

-(void) selectCardWith:(NSInteger)tag {
    if (state == 0) {
        if( tag == knownCard.number) {
            [hand addCard:knownCard];
            [self setState:1];
            if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
                [delegate respondToKnownCardChosenWithDictionary:[self gameDict]];
            }
            else {
                // Fall back on loose coupling
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Known" object:self userInfo:[self gameDict] ];
            }
        }
        else if (tag == mysteryCard.number) {
            [hand addCard:mysteryCard];
            [self setState: 1];
            if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
                [delegate respondToMysteryCardChosenWithDictionary:[self gameDict]];
            }
            else {
                // Fall back on loose coupling
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Mystery" object:self userInfo:[self gameDict] ];
            }
            
        }
        else {
            NSLog(@"Error, %d is not the mystery or known card!", tag);
        }
    }
    else {
        NSLog(@"Error, the game is in state %d and needs to be 0 to select", state);
    }
}

-(void) discardCardWith:(NSInteger)tag {
    if( state == 1 ) {
        NSMutableArray * cardsCopy = [hand.cards copy];
        for( Three13Card * card in cardsCopy ) {
            if( card.number == tag ) {
                NSLog(@"Found a match!");
                NSLog(@"Hand was %@", hand);
                [hand.cards removeObject:card];
                NSLog(@"Hand now is %@", hand);
            }
        }
        [self setState:0];
        [hand sortBySuit];
        [hand sortByValue];
        __block NSMutableDictionary * dict = [self gameDict];
        [dict setObject:@(tag) forKey:@"discard"];
        if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
            [delegate respondToCardBeingDiscardedWithDictionary:dict andCompletionHandler:^ {
                dispatch_async(global_queue, ^{
                    [self cardDiscarded];
                });
            }];
        }
        else {
            // Fall back on loose coupling
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Discard Card" object:self userInfo:[self gameDict] ];
        }
    }
}

-(NSMutableArray *) cardsInDeck {
    return deck.cards;
}

#pragma mark Three13GameDelegate callers

-(void) choseKnownCard {
    if( state == 0 ) {
        [hand addCard:knownCard];
        [self setState:1];
        if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
            [delegate respondToKnownCardChosenWithDictionary:[self gameDict]];
        }
        else {
            // Fall back on loose coupling
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Known" object:self userInfo:[self gameDict] ];
        }
    }
}

-(void) choseMysteryCard {
    if( state == 0 ) {
        //        NSLog(@"Hand starts as %@", hand);
        [hand addCard:mysteryCard];
        //        NSLog(@"Hand becomes %@", hand);
        [self setState: 1];
        if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
            [delegate respondToMysteryCardChosenWithDictionary:[self gameDict]];
        }
        else {
            // Fall back on loose coupling
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Mystery" object:self userInfo:[self gameDict] ];
        }
    }
}

-(void) choseCard:(NSInteger)number {
    if( state == 1 ) {
        NSMutableArray * cardsCopy = [hand.cards copy];
        for( Three13Card * card in cardsCopy ) {
            if( card.number == number ) {
                NSLog(@"Found a match!");
                NSLog(@"Hand was %@", hand);
                [hand.cards removeObject:card];
                NSLog(@"Hand now is %@", hand);
            }
        }
        [self setState:0];
        [hand sortBySuit];
        [hand sortByValue];
        __block NSMutableDictionary * dict = [self gameDict];
        [dict setObject:@(number) forKey:@"discard"];
        if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
            [delegate respondToCardBeingDiscardedWithDictionary:dict andCompletionHandler:^ {
                dispatch_async(global_queue, ^{
                    [self cardDiscarded];
                });
            }];
        }
        else {
            // Fall back on loose coupling
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Discard Card" object:self userInfo:[self gameDict] ];
        }
    }
}

-(void) startNewLevel {
    [self setRound:1];
    [deck reinitialize];
    [self deal:level];
    if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
        [delegate respondToStartOfLevelWithDictionary:[self gameDict]];
    }
    else {
        // Fall back on loose coupling
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Level" object:self userInfo:[self gameDict] ];
    }
    //    NSLog(@"Starting round %d level %d with score %d", round, level, totalScore );
}

-(void) endLevel {
    if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
        __block NSMutableDictionary * dict = [self gameDict];
        [delegate respondToEndOfLevelWithDictionary:dict andCompletionHandler:^ {
            dispatch_async(global_queue, ^{
                [self levelEnded];
            });
        }];
    }
    else {
        // Fall back on loose coupling
        [[NSNotificationCenter defaultCenter] postNotificationName:@"End Level" object:self userInfo:[self gameDict] ];
    }
}

#pragma mark Three13GameDelegate completion handlers

-(void) gameStarted {
    NSLog(@"View controller says game started!");
    [self startNewLevel];
}

-(void) cardDiscarded {
    [self checkForWin];
}


-(void) levelEnded {
    [self setLevel:level+1];
    [self startNewLevel];
}


@end
