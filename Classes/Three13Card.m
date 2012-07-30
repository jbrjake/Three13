//
//  Three13Card.m
//
//

#import "Three13Card.h"

@interface Three13Card(Private)

- (NSString *) valueAsString;
- (NSString *) suitAsString;

@end


@implementation Three13Card

@synthesize value, number, suit, face, back;

-(void) getFaceImage {
    //Build URL: cards/<value><suit>
    
    NSString * valueURL;
    NSString * suitURL;

    switch (self.value) {
        case 1:
            valueURL = @"a";
            break;
        case 10:
            valueURL = @"t";
            break;
        case 11:
            valueURL = @"j";
            break;
        case 12:
            valueURL = @"q";
            break;
        case 13:
            valueURL = @"k";
            break;
        default:
            valueURL = [NSString stringWithFormat:@"%d", self.value];
            break;
    }
    
    switch (self.suit) {
        case 0:
            suitURL = @"h";
            break;
        case 1:
            suitURL = @"d";
            break;
        case 2:
            suitURL = @"s";
            break;
        case 3:
            suitURL = @"c";
            break;
        default:
            suitURL = @"";
            break;
    }
    
    self.face = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.gif", valueURL, suitURL]];
    self.back = [UIImage imageNamed:@"b.gif"];
    
}

-(void) getNewFaceImage {
    //Build URL: cards/<value><suit>
    
    NSString * valueURL;
    NSString * suitURL;
    
    switch (self.value) {
        case 1:
            valueURL = @"a";
            break;
        case 11:
            valueURL = @"j";
            break;
        case 12:
            valueURL = @"q";
            break;
        case 13:
            valueURL = @"k";
            break;
        default:
            valueURL = [NSString stringWithFormat:@"%d", self.value];
            break;
    }
    
    switch (self.suit) {
        case 0:
            suitURL = @"hearts";
            break;
        case 1:
            suitURL = @"diamonds";
            break;
        case 2:
            suitURL = @"spades";
            break;
        case 3:
            suitURL = @"clubs";
            break;
        default:
            suitURL = @"";
            break;
    }
    
    self.face = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%@-150.png", suitURL, valueURL]];
    self.back = [UIImage imageNamed:@"back-blue-150-2.png"];
    
}

- (id) initWithValue:(NSInteger) aValue suit:(Suit) aSuit number:(NSInteger) aNumber {
	if(self = [super init]) {
		self.value = aValue;
		self.suit = aSuit;
        self.number = aNumber;
        [self getNewFaceImage];
	}
	return self;
}


- (NSString *) valueAsString {
	switch (self.value) {
		case Ace:
			return @"Ace";
			break;
		case Jack:
			return @"Jack";
			break;
		case Queen:
			return @"Queen";
			break;
		case King:
			return @"King";
			break;
		default:
			return [NSString stringWithFormat:@"%d",self.value];
			break;
	}
}

- (NSString *) suitAsString {
	switch (self.suit) {
		case Hearts:
			return @"Hearts";
			break;
		case Diamonds:
			return @"Diamonds";
			break;
		case Spades:
			return @"Spades";
			break;
		case Clubs:
			return @"Clubs";
			break;
		default:
			return nil;
			break;
	}
}

- (NSString *) description {
	return [NSString stringWithFormat:@"%@ of %@ (%d)",
			[self valueAsString],
			[self suitAsString], [self number]];
}

- (NSComparisonResult)compareValue:(Three13Card *)otherCard
{
    return [ @([self value]) compare: @([otherCard value])];
}

- (NSComparisonResult)compareSuit:(Three13Card *)otherCard
{
    return [ [NSNumber numberWithInt:[self suit]] compare: [NSNumber numberWithInt:[otherCard suit]]];
}

- (NSComparisonResult)compareNumber:(Three13Card *)otherCard
{
    return [ @([self number]) compare: @([otherCard number])];
}

@end
