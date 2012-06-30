//
//  Three13Deck.h
//
//

#import "Three13Card.h"

@interface Three13Deck : NSObject {

	NSMutableArray *cards;
}

@property (nonatomic, strong) NSMutableArray * cards;

- (void) reinitialize;
- (void) buildDeck;
- (void) shuffle;
- (Three13Card *) draw;
- (NSInteger) cardsRemaining;
- (NSMutableArray*) cardIDs;

@end
