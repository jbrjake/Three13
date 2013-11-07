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

-(void) addCard:( Three13Card*) card {
    [cards addObject:card];
}

-(Three13Card*) showCardAt: (NSInteger)index {
    return cards[index];
}

/**
 * @brief From http://dzone.com/snippets/generate-combinations
 * @param comb For the first run, this needs to be the ordered set of values. After that, the previous combination is inputted and modified in place.
 * @param k The number of elements to be in each combination generated
 * @param n The number of elements in the larger set from which each combination is drawn
 * @return 1 if there are more combinations, 0 if this is the last one available
 * @see -(NSMutableArray*) combinationsOf:(NSInteger)k For:(NSSet*)set
 */
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

/**
 * @brief Generates all possible combinations of size K in the given set
 * @param k The number of elements that should be in each combination
 * @param set The set of elements from which to draw each combination
 * @returns An array of the combinations
 */
-(NSMutableArray*) combinationsOf:(NSInteger)k For:(NSSet*)set {
    NSMutableArray * combinations = [[NSMutableArray alloc] init];
    int n = [set count];
    int comb[16];
    memset(comb, 0, sizeof(comb));
    int i;

    NSArray * setArray = [[NSArray alloc] initWithArray:[set allObjects]];
    NSMutableSet * tempSet;

    tempSet = [[NSMutableSet alloc] init];
    // Initialize array and begin first entry
    for (i=0; i<k; ++i) {
        comb[i] = i;
        [tempSet addObject:setArray[comb[i]]];
    }
    [combinations addObject:tempSet];
    
    while(next_comb(comb, k, n)) {
        tempSet = [[NSMutableSet alloc] init];
        for (i=0; i<k; ++i) {
            [tempSet addObject:setArray[comb[i]]];
        }
        [combinations addObject:tempSet];
    }
    return combinations;
}

/**
 * @brief Says whether or not there's a numerical sequence in a set, taking jokers into account.
 * @param set The cards to examine
 * @return True if there are sequential cards, or enough jokers to fill any gaps in them. False otherwise.
 */
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
        if (frequency[card.value-1] > 1 && card.value != joker ) {
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
    
    // There's a run if jokers can plug all the holes
    if( gap <= gapLimit )
        return TRUE;

    return FALSE;
}

-(void) findValuesSuitsAndJokers {
    /* Make sets of cards in the hand */
    [valueSets removeAllObjects];
    [suitSets removeAllObjects];
    
//    NSLog(@"Making suit and value sets");
    NSMutableSet * handSet = [[NSMutableSet alloc] initWithArray:cards];
    NSPredicate * predicate;
    NSSet * filteredSet;
    for (int i=1; i < 14; i++) {
        // Sets of cards with values 1-13
        predicate = [NSPredicate predicateWithFormat:@"value == %d",i];
        filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
        [valueSets addObject:filteredSet];
    }
    for (int i=0; i < 4; i++) {
        //Sets of cards with suits 0-3
        predicate = [NSPredicate predicateWithFormat:@"suit == %d",i];
        filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
        [suitSets addObject:filteredSet];
    }
    //Set of jokers
    predicate = [NSPredicate predicateWithFormat:@"value == %d",[cards count]];
    filteredSet = [[NSSet alloc] initWithSet:[handSet filteredSetUsingPredicate:predicate]];
    [jokerSet setSet:filteredSet];

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
    }
    // Then discard any set with count < 3 again, because some may have slipped through because of the jokers also being regular cards
    iterateArray = [[NSMutableArray alloc] initWithArray:suitSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        if ([set count] < 3 ) {
            [suitSetsWithJokers removeObject:set];
        }
    }
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
        }
    }
    
    iterateArray = [[NSMutableArray alloc] initWithArray:suitSetsWithJokers];
    for( NSSet * set in iterateArray )
    {
        int entries = [set count];
        for (int i=3; i<entries; i++) {
            NSMutableArray * combos = [self combinationsOf:i For:set];
            [suitSetsWithJokers addObjectsFromArray:combos];
        }
    }
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
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (NSSet *setB in allMeldsCopy ) {
                if (![setA intersectsSet:setB] ) {
                    //If the melds are not overlapping, combine
                    NSMutableSet * unionSet = [[NSMutableSet alloc] initWithSet:setA];
                    [unionSet unionSet:setB];
                    if (![allMelds containsObject:unionSet] && ![tempArray containsObject:unionSet]) {
                        [tempArray addObject:unionSet];
                    }
                }
            }
            [allMelds addObjectsFromArray:tempArray];
        }
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

    self.bestScore = worstScore - bestScore;
    NSLog(@"Best meld scores %d: %@", self.bestScore, bestMeld);
    
    self.score = worstScore - bestScore;
}
  
-(void) evaluateHand {
//    NSLog(@"Find value suits and jokers");
    [self findValuesSuitsAndJokers];
//    NSLog(@"Prunt sets to size");
    [self pruneSetsToSize];
//    NSLog(@"Add jokers");
    [self addJokersToSets];
//    NSLog(@"Find combos");
    [self findSetCombinations];
//    NSLog(@"Prune sets to runs");
    [self pruneSuitSetsToRuns];
//    NSLog(@"Find melds of melds");
    [self findMeldsOfMelds];
//    NSLog(@"Score hand");
    [self scoreHand];
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

@end
