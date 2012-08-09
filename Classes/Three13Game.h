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
    
    id delegate;
}

@property (nonatomic,strong) Three13Deck * deck;
@property (nonatomic,strong) Three13Hand * hand;
@property (nonatomic, strong) Three13Card * knownCard;
@property (nonatomic, strong) Three13Card * mysteryCard;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger round;
@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic, strong) id delegate;

-(void) deal: (NSInteger) cardNumber;
-(void) startGame;
-(void) gameStarted;
-(void) startNewLevel;
-(void) checkForWin;
-(void) choseKnownCard;
-(void) choseMysteryCard;
-(void) choseCard:(NSInteger)number;
-(void) cardDiscarded;
-(void) endLevel;
-(void) levelEnded;
-(NSMutableDictionary*) gameDict;
@end
