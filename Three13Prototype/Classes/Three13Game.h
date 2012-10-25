//
//  Three13Game.h
//  313-prototype
//
//  Created by Jonathon Rubin on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three13GameDelegate.h"
#import "Three13ViewDataSource.h"
#import "Three13Deck.h"

@interface Three13Game : NSObject <Three13ViewDataSource> {

    Three13Deck * deck;
    Three13Card * knownCard;
    Three13Card * mysteryCard;
    NSInteger state;
    NSInteger level;
    NSInteger round;
    NSMutableArray * players;
    NSInteger currentPlayer;
    dispatch_queue_t global_queue;
    
    id <Three13GameDelegate> delegate;
}

@property (nonatomic,strong) Three13Deck * deck;
@property (nonatomic) NSInteger state;
@property (nonatomic, strong) id <Three13GameDelegate> delegate;
@property NSMutableDictionary * firstPlayerOutForLevels;

-(void) deal: (NSInteger) cardNumber;
-(void) gameStarted;
-(void) startNewLevel;
-(void) startNewRound;
-(void) cardDiscardedByPlayerWithIndex:(NSInteger)index;
-(void) endLevel;
-(void) levelEnded;
-(void) iteratePlayers;
-(NSMutableDictionary*) gameDict;
@end
