//
//  Three13Hand.m
//  313-prototype
//
//  Created by Jonathon Rubin on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three13Hand.h"


@implementation Three13Hand

@synthesize score, suitSets, valueSets, jokerSet, suitSetsWithJokers, valueSetsWithJokers, allMelds, bestMeld;

- (id) init {
	if(self = [super init] ) {
        [cards release];
		cards = [[NSMutableArray alloc] init];
        valueSets = [[NSMutableArray alloc] init];
        suitSets = [[NSMutableArray alloc] init];
        jokerSet = [[NSMutableSet alloc] init];
        valueSetsWithJokers = [[NSMutableArray alloc] init];
        suitSetsWithJokers = [[NSMutableArray alloc] init];
        allMelds = [[NSMutableArray alloc] init];
        bestMeld = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc {
    [suitSets release];
    suitSets = nil;
    [valueSets release];
    valueSets = nil;
    [jokerSet release];
    jokerSet = nil;
    [valueSetsWithJokers release];
    valueSetsWithJokers = nil;
    [suitSetsWithJokers release];
    suitSetsWithJokers = nil;
    [allMelds release];
    allMelds = nil;
    [bestMeld release];
    bestMeld = nil;
    [super dealloc];
}
-(void) addCard:( Three13Card*) card {
    [cards addObject:card];
    [card release];
}

-(Three13Card*) showCardAt: (NSInteger)index {
    return [cards objectAtIndex:index];
}

int next_comb(int comb[], int k, int n) {
    int i = k - 1;
    ++comb[i];
    while ((i >= 0) && (comb[i] >= n - k + 1 + i)) {
        --i;
        ++comb[i];
    }
    
    if (comb[0] > n - k) /* Combination (n-k, n-k+1, ..., n) reached */
        return 0; /* No more combinations can be generated */
    
    /* comb now looks like (..., x, n, n, n, ..., n).
     Turn it into (..., x, x + 1, x + 2, ...) */
    for (i = i + 1; i < k; ++i)
        comb[i] = comb[i - 1] + 1;
    
    return 1;
}

-(NSMutableArray*) combinationsOf:(NSInteger)k For:(NSSet*)set {
    NSMutableArray * combinations = [[NSMutableArray alloc] init];
    int n = [set count];
    int comb[16];
    int i;

    NSArray * setArray = [[NSArray alloc] initWithArray:[set allObjects]];
    NSMutableSet * tempSet;

    tempSet = [[NSMutableSet alloc] init];
    // Initialize array and begin first entry
    for (i=0; i<k; ++i) {
        comb[i] = i;
        [tempSet addObject:[setArray objectAtIndex:comb[i] ]];
    }
    [combinations addObject:tempSet];
    [tempSet release];
    
    while(next_comb(comb, k, n)) {
        tempSet = [[NSMutableSet alloc] init];
        for (i=0; i<k; ++i) {
            [tempSet addObject:[setArray objectAtIndex:comb[i] ]];
        }
        [combinations addObject:tempSet];
        [tempSet release];
    }
    [setArray release];
    return combinations;
}

-(BOOL) runInSet:(NSSet *)set {
    NSInteger joker = [cards count];
    NSMutableArray * setArray = [NSMutableArray arrayWithArray:[set allObjects]];
    int frequency[13] = {0,0,0,0,0,0,0,0,0,0,0,0,0};

    //Sort set by value
    [setArray sortUsingSelector:@selector(compareValue:)];
    
    // Delete duplicate values to make finding runs easier
    NSMutableArray *setArrayCopy = [setArray copy];
    for( Three13Card * card in setArrayCopy )
    {
        frequency[card.value-1]++;
        if (frequency[card.value-1] > 1 && card.value-1 != joker ) {
            [setArrayCopy release];
            return FALSE;
        }
    }
    
    //Fimd max and min values
    int i, min, max;
    min = max = 0;
    for (i = 0; i < 13; i++) {
        if( frequency[i] && joker != i+1 )
        {
            if( !min)
                min = i+1;
            max = i+1;
        }
    }
    
    // Searching between the lowest and highest non-joker card values,
    // count every missing card for the sequence.
    int gap = 0;
    int jokerCount = frequency[joker-1];
    int gapLimit = jokerCount;
    for (i=min-1; i < max; i++) {
        if ( (!frequency[i] || joker == i+1)) {
            gap++;
        }
    }
    
    [setArrayCopy release];
    // There's a run if jokers can plug all the holes
    if( gap <= gapLimit )
        return TRUE;

    return FALSE;
}

-(void) findValuesSuitsAndJokers {
    /* Make sets of cards in the hand */
    [valueSets removeAllObjects];
    [suitSets removeAllObjects];
//    valueSets = [NSMutableArray arrayWithCapacity:13];
//    suitSets = [NSMutableArray arrayWithCapacity:4];
    
//    NSLog(@"Making suit and value sets");
    NSMutableSet * handSet = [[NSMutableSet alloc] initWithArray:cards];
    NSPredicate * predicate;
    NSSet * filteredSet;
    for (int i=1; i < 14; i++) {
        // Sets of cards with values 1-13
        predicate = [NSPredicate predicateWithFormat:@"value == %d",i];
        filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
        [valueSets addObject:filteredSet];
        [filteredSet release];
    }
    for (int i=0; i < 4; i++) {
        //Sets of cards with suits 0-3
        predicate = [NSPredicate predicateWithFormat:@"suit == %d",i];
        filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
        [suitSets addObject:filteredSet];
        [filteredSet release];
    }
    //Set of jokers
    predicate = [NSPredicate predicateWithFormat:@"value == %d",[cards count]];
    filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
    [jokerSet setSet:filteredSet];
    [filteredSet release];

    [handSet release];
    NSLog(@"Value sets: %@", [valueSets description]);
    NSLog(@"Suit sets: %@", [suitSets description]);
    NSLog(@"Joker set: %@", [jokerSet description]);    
}

-(void) pruneSetsToSize {
    //Discard sets too small to make melds even with jokers
    int jokers = [jokerSet count];
    NSArray * iterateArray = [[NSArray alloc] initWithArray:valueSets];
    for( NSSet * set in iterateArray )
    {
        if( !jokers )
        {
            if( [set count] <= 2 )
            {
                [valueSets removeObject:set];
            }
        }
        else if ( jokers == 1 )
        {
            if ([set count] <= 1 ) {
                [valueSets removeObject:set];
            }
        }
    }
    [iterateArray release];
    iterateArray = [[NSArray alloc] initWithArray:suitSets];
    for( NSSet * set in iterateArray )
    {
        if( !jokers )
        {
            if( [set count] <= 2 )
            {
                [suitSets removeObject:set];
            }
        }
        else if ( jokers == 1 )
        {
            if ([set count] <= 1 ) {
                [suitSets removeObject:set];
            }
        }
    }
    [iterateArray release];
}

-(void) addJokersToSets {
    // Time to iterate through the valuesets array
    [valueSetsWithJokers removeAllObjects];
    for( NSSet * set in valueSets ) {
        // For each set, make an array. Union with the jokers.
        NSMutableSet * jokeredSet = [[NSMutableSet alloc] initWithSet:set];
        [jokeredSet unionSet:jokerSet];
        [valueSetsWithJokers addObject:set];
        if ( ![jokeredSet isEqualToSet:set] ) {
            [valueSetsWithJokers addObject:jokeredSet];
        }
        [jokeredSet release];
    }
    // Then discard any set with count < 3 again, because some may have slipped through because of the jokers also being regular cards
    NSMutableArray * iterateArray;
    iterateArray = [[NSMutableArray alloc] initWithArray:valueSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        if ([set count] < 3 ) {
            [valueSetsWithJokers removeObject:set];
        }
    }
    [iterateArray release];
    // Time to iterate through the suitsets array
    [suitSetsWithJokers removeAllObjects];
    for( NSSet * set in suitSets ) {
        // For each set, make an array. Union with the jokers.
        NSMutableSet * jokeredSet = [[NSMutableSet alloc] initWithSet:set];
        [jokeredSet unionSet:jokerSet];
        [suitSetsWithJokers addObject:set];
        if ( ![jokeredSet isEqualToSet:set] ) {
            [suitSetsWithJokers addObject:jokeredSet];
        }
        [jokeredSet release];
    }
    // Then discard any set with count < 3 again, because some may have slipped through because of the jokers also being regular cards
    iterateArray = [[NSMutableArray alloc] initWithArray:suitSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        if ([set count] < 3 ) {
            [suitSetsWithJokers removeObject:set];
        }
    }
    [iterateArray release];
}

-(void) findSetCombinations {
    // For each set left, loop through every combination
    NSMutableArray * iterateArray;
    iterateArray = [[NSMutableArray alloc] initWithArray:valueSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        int entries = [set count];
        int i;
        for (i=3; i<entries; i++) {
            NSMutableArray * combos = [self combinationsOf:i For:set];
            [valueSetsWithJokers addObjectsFromArray:combos];
            [combos release];
        }
    }
    [iterateArray release];
    
    iterateArray = [[NSMutableArray alloc] initWithArray:suitSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        int entries = [set count];
        for (int i=3; i<entries; i++) {
            NSMutableArray * combos = [self combinationsOf:i For:set];
            [suitSetsWithJokers addObjectsFromArray:combos];
            [combos release];
        }
    }
    [iterateArray release];
}

-(void) pruneSuitSetsToRuns {
    // Now remove non runs from the suit sets
    NSMutableArray * sswjCopy = [suitSetsWithJokers copy];
    for( NSSet * set in sswjCopy ) {
        if( ![self runInSet:set] )
        {
            [suitSetsWithJokers removeObject:set];
        }
    }
    [sswjCopy release];
}

-(void) findMeldsOfMelds {
    // Add combinations of melds.    
    // First put every meld in an array
    [allMelds removeAllObjects];
    [allMelds addObjectsFromArray:valueSetsWithJokers];
    [allMelds addObjectsFromArray:suitSetsWithJokers];
    
    // There can be up to 3 levels of melds of melds
    for (int i=0; i<3; i++) {
        // Go through each meld
        NSMutableArray * allMeldsCopy = [allMelds copy];
        for (NSSet * setA in allMeldsCopy ) {
            if ([setA count] < (i+1)*3 ){
                // No need to re-compare examined melds
                //break;
            }
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (NSSet *setB in allMeldsCopy ) {
                if (![setA intersectsSet:setB] ) {
                    //If the melds are not overlapping, combine
                    NSMutableSet * unionSet = [[NSMutableSet alloc] initWithSet:setA];
                    [unionSet unionSet:setB];
                    if (![allMelds containsObject:unionSet] && ![tempArray containsObject:unionSet]) {
                        [tempArray addObject:unionSet];
                    }
                    [unionSet release];
                }
            }
            [allMelds addObjectsFromArray:tempArray];
            [tempArray release];
        }
        [allMeldsCopy release];
    }
    
//    NSLog(@"All melds: %@", allMelds);    
}

-(NSInteger) worstScoreForThree13Hand {
    int worstScore = 0;
    for( Three13Card * card in cards ) {
        worstScore += MIN(card.value, 10);
    }
    return worstScore;
}

-(void) scoreHand {
    int bestScore = 0;
    int meldScore;
    [bestMeld removeAllObjects];
    NSLog(@"Valid melds: %@", allMelds);
    for (NSSet * meld in allMelds) {
        meldScore = 0;
        for (Three13Card * card in meld) {
            meldScore += MIN(card.value, 10);
        }
        if (meldScore > bestScore ) {
            bestScore = meldScore;
            [bestMeld removeAllObjects];
            [bestMeld addObjectsFromArray:[meld allObjects]];
            [bestMeld sortUsingSelector:@selector(compareSuit:)];
            [bestMeld sortUsingSelector:@selector(compareValue:)];
        }
    }
    
    // Sort by suit and value
    int worstScore = [self worstScoreForThree13Hand];

    score = worstScore - bestScore;
    NSLog(@"Best meld scores %d: %@", score, bestMeld);
}
  
-(void) evaluateHand {
//    [self printCardRetainCounts];
      NSLog(@"Find value suits and jokers");
    [self findValuesSuitsAndJokers];
//    [self printCardRetainCounts];
      NSLog(@"Prunt sets to size");
    [self pruneSetsToSize];
//    [self printCardRetainCounts];
    NSLog(@"Add jokers");
    [self addJokersToSets];
//    [self printCardRetainCounts];
    NSLog(@"Find combos");
    [self findSetCombinations];
//    [self printCardRetainCounts];
    NSLog(@"Prune sets to runs");
    [self pruneSuitSetsToRuns];
//    [self printCardRetainCounts];
    NSLog(@"Find melds of melds");
    [self findMeldsOfMelds];
//    [self printCardRetainCounts];
    NSLog(@"Score hand");
    [self scoreHand];
//    [self printCardRetainCounts];
}

-(void) updateScore {
    [self evaluateHand];
    [self sortByValue];
}

-(void) sortByValue {
    [cards sortUsingSelector:@selector(compareValue:)];
}

-(void) sortBySuit {
    [cards sortUsingSelector:@selector(compareSuit:)];
}

-(void) printCardRetainCounts {
    for (Three13Card * card in cards) {
        NSLog(@"Card retained %d times", [card retainCount]);
    }
}

@end
