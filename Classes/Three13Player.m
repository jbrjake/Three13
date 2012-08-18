//
//  Three13Player.m
//  313-prototype
//
//  Created by Jonathon Rubin on 8/17/12.
//
//

#import "Three13Player.h"

@implementation Three13Player

@synthesize hand, state, currentScore, totalScore;

-(id) init  {
    if( self = [super init] ) {
        hand = [[Three13Hand alloc] init];
        state = -1;
        totalScore = 0;
        currentScore = 0;
    }
    return self;
}
@end
