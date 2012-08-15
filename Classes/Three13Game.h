//
//  Three13Game.h
//  313-prototype
//
//  Created by Jonathon Rubin on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three13Hand.h"
#import "Three13GameDelegate.h"
#import "Three13ViewDataSource.h"

@interface Three13Game : NSObject <Three13ViewDataSource> {

    Three13Deck * deck;
    Three13Hand * hand;
    Three13Card * knownCard;
    Three13Card * mysteryCard;
    NSInteger state;
    NSInteger level;
    NSInteger round;
    NSInteger currentScore;
    NSInteger totalScore;
    dispatch_queue_t global_queue;
    
    id <Three13GameDelegate> delegate;
}

@property (nonatomic,strong) Three13Deck * deck;
@property (nonatomic,strong) Three13Hand * hand;
@property (nonatomic, strong) id <Three13GameDelegate> delegate;

-(void) deal: (NSInteger) cardNumber;
-(void) gameStarted;
-(void) startNewLevel;
-(void) checkForWin;
-(void) choseKnownCard;
-(void) choseMysteryCard;
-(void) choseCard:(NSInteger)number;
-(void) cardDiscarded;
-(void) endLevel;
-(void) levelEnded;
-(NSMutableArray*) allCards;
-(NSMutableDictionary*) gameDict;
@end
