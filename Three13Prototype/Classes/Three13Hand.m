//
//  Three13Hand.m
//  313-prototype
//
//  Created by Jonathon Rubin on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Three13Hand.h"


@implementation Three13Hand

@synthesize score, validRuns, validValueSets, allValidMelds, suitSets, valueSets, jokerSet, suitSetsWithJokers, valueSetsWithJokers, allMelds, bestMeld, bestValidMeld;

#pragma mark Lifecycle

/**
 * @brief Very basic init method, does not but initialize ivars
 */
- (id) init {
	if(self = [super init] ) {
		cards = [[NSMutableArray alloc] init];
        validRuns = [[NSMutableArray alloc] init];
        validValueSets = [[NSMutableArray alloc] init];
        allValidMelds = [[NSMutableArray alloc] init];
        valueSets = [[NSMutableArray alloc] init];
        suitSets = [[NSMutableArray alloc] init];
        jokerSet = [[NSMutableSet alloc] init];
        valueSetsWithJokers = [[NSMutableArray alloc] init];
        suitSetsWithJokers = [[NSMutableArray alloc] init];
        allMelds = [[NSMutableArray alloc] init];
        bestMeld = [[NSMutableArray alloc] init];
        bestValidMeld = [[NSMutableArray alloc] init];
	}
	return self;
}

#pragma mark Data structure modification and search

/**
 * @brief Empties the cards and evaluation arrays and resets the scores
 */
-(void) clearHand {
    [cards removeAllObjects];
    [validRuns removeAllObjects];
    [validValueSets removeAllObjects];
    [allValidMelds removeAllObjects];
    [valueSets removeAllObjects];
    [suitSets removeAllObjects];
    [jokerSet removeAllObjects];
    [valueSetsWithJokers removeAllObjects];
    [suitSetsWithJokers removeAllObjects];
    [allMelds removeAllObjects];
    [bestMeld removeAllObjects];
    [bestValidMeld removeAllObjects];
    self.score = 0;
    self.bestScore = 0;
}

/**
 * @brief Simple pass-through for other classes to add cards to the card array
 */
-(void) addCard:( Three13Card*) card {
    [cards addObject:card];
}

/**
 * @brief Simple pass-through for other classes to access card array indicies
 */
-(Three13Card*) showCardAt: (NSInteger)index {
    return cards[index];
}

/**
 * @brief Sorts the card array in-place, with ascending card.values
 */
-(void) sortByValue {
    [cards sortUsingSelector:@selector(compareValue:)];
}

/**
 * @brief Sorts the card array in-place by suit
 */
-(void) sortBySuit {
    [cards sortUsingSelector:@selector(compareSuit:)];
}

#pragma mark Potential meld identification

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

/**
 * @brief Populates the valueSets, suitSets, and jokerSet ivars
 *
 * valueSets stores sets containing all cards in-hand with every possible card.value
 *
 * suitSets stores sets containing all cards in-hand for each card.suit
 *
 * jokerSet stores the set of all jokers in the hand
 */
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

/**
 * @brief Discards potential sets too small to make melds, even with jokers
 */

-(void) pruneSetsToSize {
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

/**
 * @brief Seeds valueSetsWithJokers and suitSetsWithJokers
 *
 * Finds all unions of valueSets and suitSets with the jokerSet
 */
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
 * @brief Fleshes out valueSetsWithJokers and suitSetsWithJokers with all possible combinations of cards
 */
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

/**
 * @brief Removes non-run combinations from suitSetsWithJokers
 */
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

/**
 * Populates potential meld arrays (suitSets, valueSets, suitSetsWithJokers, and valueSetsWithJokers) with all possible combination
 */
-(void) findPotentialMelds {
    [self findValuesSuitsAndJokers];
    [self pruneSetsToSize];
    [self addJokersToSets];
    [self findSetCombinations];
    [self pruneSuitSetsToRuns];
}

#pragma mark Valid meld detection

/**
 * @brief Says whether or not there's a numerical sequence in an ordered set, taking jokers into account.
 * @param set The cards to examine
 * @return True if there are sequential cards, or enough jokers to fill any gaps in them. False otherwise.
 *
 * This method first makes sure that all runs are in the same suit or jokers, and that here are at least 3 cards
 * 
 * Then, it builds sorted (ascending and descending) arrays of all non-joker cards in the hand.
 *
 * After that it adds the jokers back to their original locations in the sorted arrays.
 *
 * Finally, it checks to see if either of the reassembled series of cards matches the actual hand.
 *
 */
-(BOOL) runInOrderedSet:(NSOrderedSet *)set {
	BOOL retValue = FALSE;
    BOOL areDifferentSuits = FALSE;
    BOOL areTooFewCards = FALSE;
    BOOL areGaps = FALSE;
    BOOL areReverseGaps = FALSE;
    BOOL isPotentialRun = [self runInSet:[set set]];
    BOOL isInOrder = FALSE;
    NSInteger joker = [cards count];
    NSMutableArray * setArray = [NSMutableArray arrayWithArray:[set array]];
    
    // Test if the cards are all from the same suit, or jokers
    int theSuit = -1;
    for (Three13Card * card in setArray) {
        if (theSuit == -1 && card.value != joker) {
            theSuit = card.suit;
        }
        if (card.suit != theSuit && card.value != joker) {
            areDifferentSuits = TRUE;
        }
    }

    // Test if there are enough cards (3) to form a meld
    if (setArray.count < 3) {
        areTooFewCards = TRUE;
    }
    
    // These will store jokers extracted from the set, for use in ascending and descending order
    NSMutableArray * jokers = [[NSMutableArray alloc] init];
    NSMutableArray * reverseJokers = [[NSMutableArray alloc] init];

    // The arrays will hold the optimal layout of cards: all either ascending and descending in sequence
    NSMutableArray * sortedArray = [[NSMutableArray alloc] initWithArray:setArray];
    NSMutableArray * reverseSortedArray = [[NSMutableArray alloc] initWithArray:setArray];
    
    // Remove jokers from the to-be-sorted arrays and store them in the jokers and reverseJokers arrays
    for (Three13Card * card in setArray) {
        if (card.value == joker) {
            [sortedArray removeObject:card];
            [reverseSortedArray removeObject:card];
            [jokers addObject:card];
            [reverseJokers addObject:card];
        }
    }
    
    // Ascending and descending sort
    [sortedArray sortUsingSelector:@selector(compareValue:)];
    [reverseSortedArray sortUsingSelector:@selector(reverseCompareValue:)];

    // Return jokers to their original locations
    for (Three13Card * card in jokers) {
        int i = [setArray indexOfObject:card];
        [sortedArray insertObject:card atIndex:i];
    }
    [jokers removeAllObjects];
    
    for (Three13Card * card in reverseJokers) {
        int i = [setArray indexOfObject:card];
        [reverseSortedArray insertObject:card atIndex:i];
    }
    [reverseJokers removeAllObjects];
    
    // Make sure all gaps are filled
    for (int i = 0; i < sortedArray.count-1; i++) {
        Three13Card * cur = sortedArray[i];
        Three13Card * next = sortedArray[i+1];
        if (cur.value != next.value-1 && !(cur.value == joker || next.value == joker) ) {
            // We have still have a gap after adding jokers
            areGaps = TRUE;
        }
    }
    for (int i = 0; i < reverseSortedArray.count-1; i++) {
        Three13Card * cur = reverseSortedArray[i];
        Three13Card * next = reverseSortedArray[i+1];
        if (cur.value != next.value+1 && !(cur.value == joker || next.value == joker) ) {
            // We have still have a gap after adding jokers
            areReverseGaps = TRUE;
        }
    }
    
    // Check if either sorted array matches the actual hand and has no gaps
    if (!areGaps && [sortedArray isEqualToArray:setArray]) {
        isInOrder = TRUE;
    }
    else if (!areReverseGaps && [reverseSortedArray isEqualToArray:setArray]) {
        isInOrder = TRUE;
    }
    
    // We have a run if the cards are the same suit, are in sufficient number, can make a run, and the hand is sorted correctly and has no gaps in numbering not filled by a joker
    retValue = ( !areDifferentSuits && !areTooFewCards &&
                 isPotentialRun && isInOrder ) ;
    
    return retValue;
}

/**
 * @brief Says whether or not all cards in an ordered set are the same value, taking jokers into account.
 * @param set The cards to examine
 * @return True if they are al the same value, or there are enough jokers to fill any gaps in them. False otherwise.
 *
 */
-(BOOL) valueSetInOrderedSet:(NSOrderedSet *)set {
	BOOL retValue = FALSE;
    BOOL areDifferentValues = FALSE;
    BOOL areTooFewCards = FALSE;
    NSInteger joker = [cards count];
    NSMutableArray * setArray = [NSMutableArray arrayWithArray:[set array]];
    
    // Test if the cards have the same value, or are jokers
    int theValue = -1;
    for (Three13Card * card in setArray) {
        if (theValue == -1 && card.value != joker) {
            theValue = card.value;
        }
        if (card.value != theValue && card.value != joker) {
            areDifferentValues = TRUE;
        }
    }
    
    // Test if there are enough cards (3) to form a meld
    if (setArray.count < 3) {
        areTooFewCards = TRUE;
    }
    
    retValue = ( !areDifferentValues && !areTooFewCards ) ;
    
    return retValue;
}

/**
 * @brief Populates validRuns and validValueSets by considering every possible window of meldable cards in the current hand order
 *
 * 1-3 -> 1-13
 *
 * 2-4 -> 2-13
 *
 * etc.
 */
-(void) findValidMelds {
    // For every starting position make a set of the next m = (start+2 -> n) elements
    // and if it's valid, add it to a collection
    for (int start = 0; start < cards.count-2; start++) {
        for (int end = start+2; end < cards.count; end++) {
            NSMutableOrderedSet * set = [[NSMutableOrderedSet alloc] init];
            for (int i = start; i < end+1; i++) {
                [set addObject:cards[i]];
            }
            if (set.count && [self runInOrderedSet:set]) {
                [self.validRuns addObject:set];
            }
            if (set.count && [self valueSetInOrderedSet:set]) {
                [self.validValueSets addObject:set];
            }
        }
    }
}

#pragma mark Hand evaluation

/**
 * @brief Populates allMelds and allValidMelds by iterating through each non-overlapping union of known potential and valid melds
 */
-(void) findMeldsOfMelds {
    // Add combinations of melds.    
    // First put every meld in an array
    [allMelds removeAllObjects];
    [allMelds addObjectsFromArray:valueSetsWithJokers];
    [allMelds addObjectsFromArray:suitSetsWithJokers];
    [allValidMelds removeAllObjects];
    [allValidMelds addObjectsFromArray:validRuns];
    [allValidMelds addObjectsFromArray:validValueSets];
    
    // There can be up to 3 levels of melds of melds
    for (int i=0; i<3; i++) {
        // Go through each possible meld
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
        // Go through each valid meld
        allMeldsCopy = [allValidMelds copy];
        for (NSOrderedSet * setA in allMeldsCopy ) {
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (NSOrderedSet *setB in allMeldsCopy ) {
                if (![setA intersectsOrderedSet:setB] ) {
                    //If the melds are not overlapping, combine
                    NSMutableOrderedSet * unionSet = [[NSMutableOrderedSet alloc] initWithOrderedSet:setA];
                    [unionSet unionOrderedSet:setB];
                    if (![allValidMelds containsObject:unionSet] && ![tempArray containsObject:unionSet]) {
                        [tempArray addObject:unionSet];
                    }
                }
            }
            [allValidMelds addObjectsFromArray:tempArray];
        }
    }
}

/**
 * @brief Returns the sum of values for the cards in a collection
 */
-(int) sumOfCardsIn:(NSArray*)cardArray {
    int sum = 0;
    for( Three13Card * card in cardArray ) {
        sum += MIN(card.value, 10); // Face cards are clamped to 10 points
    }
    return sum;
}

/**
 * @brief Finds the potential meld that contains the greatest number of points
 * @return The greatest number of points that can be sunk into a meld, assuming an optimal hand arrangement
 * Each possible meld (the collections in allMelds) is examined, looking for the meld that contains the most points.
 * That highest-scoring meld (i.e., the one keeping the greatest number of points from going unmelded) is
 * stored in bestMeld, and sorted by suit and value.
 */
-(int) findBestScore {
    int bestScore = 0;
    int meldScore;
    [bestMeld removeAllObjects];
    for (NSSet * meld in allMelds) {
        meldScore = [self sumOfCardsIn:[meld allObjects]];
        if (meldScore > bestScore ) {
            bestScore = meldScore;
            [bestMeld removeAllObjects];
            [bestMeld addObjectsFromArray:[meld allObjects]];
            [bestMeld sortUsingSelector:@selector(compareSuit:)];
            [bestMeld sortUsingSelector:@selector(compareValue:)];
        }
    }
    return bestScore;
}

/**
 * @brief The score of the hand assuming no melds
 * @return The values of all cards in the hand added together
 */
-(int) findWorstScore {
    return [self sumOfCardsIn:cards];
}

/**
 * @brief Finds the actual meld that contains the greatest number of points
 * @return The greatest number of points that can be sunk into a meld, assuming the current hand arrangement
 * Each actual meld (the collections in allValidMelds) is examined, looking for the meld that contains the most points.
 * That highest-scoring meld (i.e., the one keeping the greatest number of points from going unmelded) is
 * stored in bestValidMeld.
 */
-(int) findActualScore {
    int bestScore = 0;
    int meldScore;
    [bestValidMeld removeAllObjects];
    for (NSOrderedSet * meld in allValidMelds) {
        meldScore = [self sumOfCardsIn:[meld array]];
        if (meldScore > bestScore ) {
            bestScore = meldScore;
            [bestValidMeld removeAllObjects];
            [bestValidMeld addObjectsFromArray:[meld array]];
        }
    }
    return bestScore;
}

/**
 * @brief populates bestScore and score by finding the worst possible score, and then subtracting the melded cards from the potential and actual highest-value melds
 */
-(void) scoreHand {
    int bestScore = [self findBestScore];
    int worstScore = [self findWorstScore];
    int actualScore = [self findActualScore];

    self.bestScore = worstScore - bestScore;
    self.score = worstScore - actualScore;
}

/**
 * @brief Builds collections of potential and valid melds and their supersets, the hand's score, and the hand's best possible score if it was reordered.
 */
-(void) evaluateHand {
    [self findPotentialMelds];
    [self findValidMelds];
    [self findMeldsOfMelds];
    [self scoreHand];
}

/**
 * @brief Public-facing method for the game to recalculate scores after an event
 */
-(void) updateScore {
    [self evaluateHand];
    [self sortByValue];
}

@end
