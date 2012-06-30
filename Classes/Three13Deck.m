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
	return self;
}

/*
 * Random sort used from this blog post
 * http://zaldzbugz.wordpress.com/2010/07/16/randomly-sort-nsarray/
 */
int randomSort(id obj1, id obj2, void *context ) {
	// returns random number -1 0 1
	return (arc4random()%3 - 1);    
}

- (void) shuffle {
	for(int x = 0; x < 500; x++) {
		[cards sortUsingFunction:randomSort context:nil];
	}
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
