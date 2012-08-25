//
//  Three13Game.m
//  313-prototype
//
//  Created by Jonathon Rubin on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three13Game.h"
#import "Three13Player.h"

@implementation Three13Game

@synthesize deck, mysteryCard, knownCard, state, level, round, players, currentPlayer, delegate;

-(id) init  {
    if( self = [super init] ) {
        deck = [[Three13Deck alloc] init];
        knownCard = [[Three13Card alloc] init];
        mysteryCard = [[Three13Card alloc] init];
        state = -1;
        level = 3;
        round = 1;
#warning Assuming just one player for now
        players = [[NSMutableArray alloc] init];
        [players addObject: [[Three13Player alloc] init] ];
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
    
    for (Three13Player * player in players) {
        [player.hand.cards removeAllObjects];
        for( int i = 0; i < cardNumber; i++ ) {
            [player.hand addCard: [deck draw]];
        }
        [player.hand sortBySuit];
        [player.hand sortByValue];
        [player.hand updateScore];
        [player setCurrentScore:player.hand.score];
    }
    knownCard = [deck draw];
    mysteryCard = [deck draw];
}

-(void) checkForWinWithPlayer:(Three13Player* )player {
    //First check for going out
    //Then check for out of time
    int ret = [player checkForWinWith:[self gameDict]];
    
    switch (ret) {
        case -1:
            // Keep going
            // Deal new mystery/known cards
            knownCard = [deck draw];
            mysteryCard = [deck draw];
            if (players.count == [players indexOfObject:player]+1) {
                // If this is the last player, start a new round
                [self startNewRound];
            }
            break;
        case  0:
            // Out of rounds
            [player setTotalScore:player.totalScore + player.hand.score];
            if (players.count == [players indexOfObject:player]+1) {
                // This is the last player to score, end level
                [self endLevel];
            }
            else {
                // On to the next player
                knownCard = [deck draw];
                mysteryCard = [deck draw];
            }
            break;
        case  1:
            // It's a win
            if (players.count == [players indexOfObject:player]+1) {
                [self endLevel];
            }
            else {
                // On to the next player
                knownCard = [deck draw];
                mysteryCard = [deck draw];
            }
            break;
        default:
            break;
    }
}

-(NSMutableDictionary *) gameDict {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: players, @"players", [deck cardIDs], @"deck", @(knownCard.number), @"known", @(mysteryCard.number), @"mystery", @0, @"discard", @(level), @"level", @(round), @"round", nil ];
    return dict;
}

-(NSMutableArray *) allCards {
    NSMutableArray * returnArray = [[NSMutableArray alloc] init];
    [returnArray addObjectsFromArray:deck.cards];
    for (Three13Player * player in players) {
        [returnArray addObjectsFromArray:player.hand.cards];
    }
    [returnArray addObject:mysteryCard];
    [returnArray addObject:knownCard];
    return returnArray;
}

#pragma mark Three13ViewDataSource protocol implementation

-(void) startGame {
    [self deal:level];
    for (Three13Player * player in players) {
        [player.hand updateScore];
    }
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
        NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
    }
}

-(void) selectCardWith:(NSInteger)tag {
    
#warning Assuming just one player for now
    Three13Player * player = [players objectAtIndex:0];
    if (state == 0) {
        if( tag == knownCard.number) {
            [player.hand addCard:knownCard];
            [self setState:1];
            if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
                [delegate respondToKnownCardChosenWithDictionary:[self gameDict]];
            }
            else {
                NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
            }
        }
        else if (tag == mysteryCard.number) {
            [player.hand addCard:mysteryCard];
            [self setState: 1];
            if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
                [delegate respondToMysteryCardChosenWithDictionary:[self gameDict]];
            }
            else {
                NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
            }            
        }
        else {
            NSLog(@"Error, %d is not the mystery or known card!", tag);
        }
    }
    else {
        NSMutableArray * cardsCopy = [player.hand.cards copy];
        for( Three13Card * card in cardsCopy ) {
            if( card.number == tag ) {
                NSLog(@"Found a match!");
                NSLog(@"Hand was %@", player.hand);
                [player.hand.cards removeObject:card];
                NSLog(@"Hand now is %@", player.hand);
            }
        }
        [self setState:0];
        [player.hand sortBySuit];
        [player.hand sortByValue];
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
            NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
        }
    }
}

-(NSMutableArray *) cardsInDeck {
    return deck.cards;
}

#pragma mark Three13GameDelegate callers

-(void) startNewLevel {
    [deck reinitialize];
    [self setRound:1];
    [self deal:level];
    if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
        [delegate respondToStartOfLevelWithDictionary:[self gameDict]];
    }
    else {
        NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
    }
    //    NSLog(@"Starting round %d level %d with score %d", round, level, totalScore );
}

-(void) startNewRound {
    [self setRound:round+1];
    if( [delegate conformsToProtocol:@protocol(Three13GameDelegate)] ) {
        [delegate respondToStartOfRoundWithDictionary:[self gameDict]];
    }
    else {
        NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
    }
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
        NSLog(@"%s: delegate does not conform to protocol", __PRETTY_FUNCTION__);
    }
}

#pragma mark Three13GameDelegate completion handlers

-(void) gameStarted {
    NSLog(@"View controller says game started!");
    [self startNewLevel];
}

-(void) cardDiscarded {
#warning Assuming just one player for now.
    [self checkForWinWithPlayer:[players objectAtIndex:0]];
}


-(void) levelEnded {
    [self setLevel:level+1];
    [self startNewLevel];
}


@end
