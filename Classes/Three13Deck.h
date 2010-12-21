//
//  Three13Deck.h
//
//

#import "Three13Card.h"

@interface Three13Deck : NSObject {

	NSMutableArray *cards;
}

@property (nonatomic, retain) NSMutableArray * cards;

- (void) shuffle;
- (Three13Card *) draw;
- (NSInteger) cardsRemaining;

@end
