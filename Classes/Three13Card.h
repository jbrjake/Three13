//
//  Three13Card.h
//
//

typedef enum {
	Hearts,
	Diamonds,
	Spades,
	Clubs
} Suit;

#define Ace   1
#define Jack  11
#define Queen 12
#define King  13

@interface Three13Card : NSObject {
	NSInteger number;
    NSInteger value;
	Suit suit;
    UIImage * face;
    UIImage * back;
}

@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger number;
@property (nonatomic) Suit suit;
@property (nonatomic, strong) UIImage * face;
@property (nonatomic, strong) UIImage * back;

- (id) initWithValue:(NSInteger) aValue suit:(Suit) aSuit number:(NSInteger) aNumber;
-(void) getFaceImage;
- (NSComparisonResult)compareValue:(Three13Card *)otherCard;
- (NSComparisonResult)compareSuit:(Three13Card *)otherCard;
- (NSComparisonResult)compareNumber:(Three13Card*)otherCard;
@end
