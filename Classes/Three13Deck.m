//
//  Three13Deck.m
//
//

#import "Three13Deck.h"

@implementation Three13Deck

@synthesize cards;

- (id) init {
	if(self = [super init]) {
//        NSLog(@"Hit Three13Deck init, making cards now");
		cards = [[NSMutableArray alloc] init];
        [self buildDeck];
	}
	return self;
}

- (void) reinitialize {
    cards = [[NSMutableArray alloc] init];
    [self buildDeck];
}

- (void) buildDeck {
    NSInteger counter = 0;
    for (int decks = 0; decks < 2; decks++) {
        for(int suit = 0; suit <= 3; suit++) {
            for(int value = 1; value <= 13; value++) {
                Three13Card *card = [[Three13Card alloc] initWithValue:value suit:suit number:counter];
                [cards addObject:card];
                counter++;
            }
        }            
    }
}

/*
 * Random sort used from this blog post
 * http://zaldzbugz.wordpress.com/2010/07/16/randomly-sort-nsarray/
 */
int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1
	return (arc4random()%3 - 1);    
}

/**
 * Fills an array with 500 entries where each is a random choice of -1, 0, or 1.
 * Then it uses those to sort the card array 500 times.
 */
- (void) shuffle {
    
    // GCD has a bug preventing access to arrays if they're not wrapped in a struct
    // http://www.cocoabuilder.com/archive/cocoa/296710-cannot-access-block-variable-of-array-type-inside-block.html
    __block struct {
        int randomArray[500];
    } blockStruct;
    
    // Concurrently fills in randomArray as a lookup table for random numbers
    dispatch_apply((size_t)500, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t i) {
        blockStruct.randomArray[i] = randomSort(nil, nil, nil); 
    });
    
    // Serially performs 500 sort operations on the card array, each time using a different random
    // sort direction from the random lookup table. This is a bit convoluted, but necessary since
    // NSMutableArrays are not thread-safe. So while the random numbers can be generated concurrently
    // on the global queue, the sorting must occur in a serial queue.
    dispatch_queue_t queue;
    queue = dispatch_queue_create("us.ubiquit.313CardSorter", NULL);
    dispatch_apply((size_t)500, queue, ^(size_t j) {
        [cards sortUsingComparator:(NSComparator)^(id obj1, id obj2){
            return blockStruct.randomArray[j];
        }];
    });
}
- (Three13Card *) draw {
	
	if([self cardsRemaining] > 0) {
		Three13Card *card = [cards lastObject];
		[cards removeLastObject];
//        NSLog(@"Drawing a %@", card);
		return card;
	}
	
	NSException* myException = [NSException
								exceptionWithName:@"OutOfThree13CardsException"
								reason:@"Tried to draw a card from a deck with 0 cards."
								userInfo:nil];
	@throw myException;
}

- (NSInteger) cardsRemaining {
	return [cards count];
}

-(NSMutableArray*) cardIDs {
    NSMutableArray * cardIDs = [NSMutableArray new];
    for (Three13Card * card in cards) {
        [cardIDs addObject:[NSNumber numberWithInt:card.number]];
    }
    return cardIDs;
}

- (NSString *) description {
	NSString *desc = [NSString stringWithFormat:@"Three13Deck with %d cards\n",[self cardsRemaining]];
	for(int x = 0; x < [self cardsRemaining]; x++) {
		desc = [desc stringByAppendingFormat:@"%@\n",[[cards objectAtIndex:x] description]];
	}
	return desc;
}


@end
