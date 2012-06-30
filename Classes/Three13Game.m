//
//  Three13Game.m
//  313-prototype
//
//  Created by Jonathon Rubin on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three13Game.h"


@implementation Three13Game

@synthesize deck, hand, mysteryCard, knownCard, state, level, round, currentScore, totalScore;

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
    }
    return self;
}


-(void) testGame {

    //Build some test hands
    Three13Hand * testHand1 = [[Three13Hand alloc] init];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:4 suit:Hearts number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];

    [testHand1 updateScore];
    Three13Hand * testHand2 = [[Three13Hand alloc] init];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Clubs number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Hearts number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
            
    [testHand2 updateScore];

    Three13Hand * testHand3 = [[Three13Hand alloc] init];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:1 suit:Hearts number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:4 suit:Clubs number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:10 suit:Hearts number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:11 suit:Hearts number:0]];
    
    [testHand3 updateScore];
    
    
    NSLog(@"Test hand 1 %@, thinks it scores %d with cards %@", testHand1.score == 11 ? @"PASSED" : @"FAILED", testHand1.score, testHand1.cards);
    NSLog(@"Test hand 2 %@, thinks it scores %d with cards %@", testHand2.score == 0? @"PASSED" : @"FAILED", testHand2.score, testHand2.cards);
    NSLog(@"Test hand 3 %@, thinks it scores %d with cards %@", testHand3.score == 1? @"PASSED" : @"FAILED", testHand3.score, testHand3.cards);
}

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Game" object:self userInfo:[self gameDict] ];
}

-(void) gameStarted {
    NSLog(@"View controller says game started!");
    [self startNewLevel];
}

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

-(void) choseKnownCard {
    if( state == 0 ) {
        [hand addCard:knownCard];
        [self setState:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Known" object:self userInfo:[self gameDict] ];
    }
}

-(void) choseMysteryCard {
    if( state == 0 ) {
//        NSLog(@"Hand starts as %@", hand);
        [hand addCard:mysteryCard];
//        NSLog(@"Hand becomes %@", hand);
        [self setState: 1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Choose Mystery" object:self userInfo:[self gameDict] ];
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
        NSMutableDictionary * dict = [self gameDict];
        [dict setObject:[NSNumber numberWithInt:number] forKey:@"discard"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Discard Card" object:self userInfo:dict];
    }
}

-(void) cardDiscarded {
    [self checkForWin];
}

-(void) startNewLevel {
    [self setRound:1];
    [deck init];
    [self deal:level];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Level" object:self userInfo:[self gameDict] ];
//    NSLog(@"Starting round %d level %d with score %d", round, level, totalScore );
}

-(void) endLevel {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"End Level" object:self userInfo:[self gameDict] ];
}

-(void) levelEnded {
    [self setLevel:level+1];
    [self startNewLevel];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Round" object:self userInfo:[self gameDict] ];
    }

}

-(NSMutableDictionary *) gameDict {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: [hand cardIDs], @"hand", [deck cardIDs], @"deck", [NSNumber numberWithInt:knownCard.number], @"known", [NSNumber numberWithInt:mysteryCard.number], @"mystery", [NSNumber numberWithInt:0], @"discard", nil ];
    return dict;
}

@end
