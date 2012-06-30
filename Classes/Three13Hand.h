//
//  Three13Hand.h
//  313-prototype
//
//  Created by Jonathon Rubin on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three13Deck.h"

@interface Three13Hand : Three13Deck {
    NSInteger score;
    NSMutableArray * valueSets;
    NSMutableArray * suitSets;
    NSMutableArray * valueSetsWithJokers;
    NSMutableArray * suitSetsWithJokers;
    NSMutableArray * allMelds;
    NSMutableArray * bestMeld;
    NSMutableSet * jokerSet;

}

@property(nonatomic) NSInteger score;
@property(nonatomic, strong) NSMutableArray * valueSets;
@property(nonatomic, strong) NSMutableArray * suitSets;
@property(nonatomic, strong) NSMutableArray * valueSetsWithJokers;
@property(nonatomic, strong) NSMutableArray * suitSetsWithJokers;
@property(nonatomic, strong) NSMutableArray * allMelds;
@property(nonatomic, strong) NSMutableSet * jokerSet;
@property(nonatomic, strong) NSMutableArray * bestMeld;

-(void) addCard:( Three13Card*) card;
-(Three13Card*) showCardAt:( NSInteger) index;
-(void) sortByValue;
-(void) sortBySuit;
-(void) findValuesSuitsAndJokers;
-(void) pruneSetsToSize;
-(void) addJokersToSets;
-(void) findSetCombinations;
-(void) pruneSuitSetsToRuns;
-(void) findMeldsOfMelds;
-(void) scoreHand;
-(void) evaluateHand;
-(void) updateScore;
@end
