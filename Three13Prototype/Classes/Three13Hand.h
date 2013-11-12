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
    NSMutableArray * validRuns;
    NSMutableArray * validValueSets;
    NSMutableArray * allValidMelds;
    NSMutableArray * valueSets;
    NSMutableArray * suitSets;
    NSMutableArray * valueSetsWithJokers;
    NSMutableArray * suitSetsWithJokers;
    NSMutableArray * allMelds;
    NSMutableArray * bestMeld;
    NSMutableArray * bestValidMeld;
    NSMutableSet * jokerSet;

}

@property(nonatomic) NSInteger score;
@property(nonatomic) NSInteger bestScore;
@property(nonatomic, strong) NSMutableArray * validRuns;
@property(nonatomic, strong) NSMutableArray * validValueSets;
@property(nonatomic, strong) NSMutableArray * allValidMelds;
@property(nonatomic, strong) NSMutableArray * valueSets;
@property(nonatomic, strong) NSMutableArray * suitSets;
@property(nonatomic, strong) NSMutableArray * valueSetsWithJokers;
@property(nonatomic, strong) NSMutableArray * suitSetsWithJokers;
@property(nonatomic, strong) NSMutableArray * allMelds;
@property(nonatomic, strong) NSMutableSet * jokerSet;
@property(nonatomic, strong) NSMutableArray * bestMeld;
@property(nonatomic, strong) NSMutableArray * bestValidMeld;

-(void) addCard:( Three13Card*) card;
-(Three13Card*) showCardAt:( NSInteger) index;
-(void) sortByValue;
-(void) sortBySuit;
-(void) findValuesSuitsAndJokers;
-(void) pruneSetsToSize;
-(void) addJokersToSets;
-(void) findSetCombinations;
-(NSMutableArray*) combinationsOf:(NSInteger)k For:(NSSet*)set;
-(BOOL) runInSet:(NSSet *)set;
-(BOOL) runInOrderedSet:(NSOrderedSet *)set;
-(void) pruneSuitSetsToRuns;
-(void) findMeldsOfMelds;
-(void) scoreHand;
-(void) evaluateHand;
-(void) updateScore;

int next_comb(int comb[], int k, int n);

@end
