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
        state = 0;
        totalScore = 0;
        currentScore = 0;
    }
    return self;
}

//  0 = keep going
//  1 = win
-(int) checkForWinWith:(NSMutableDictionary *)dict {
    //First check for going out
    //Then check for out of time
    
    int ret = 0;
    
    [hand updateScore];
    [self setCurrentScore:hand.score];

    if (hand.score == 0) {
        //        NSLog(@"It's a win!");
        ret = 1;
    }

    return ret;
}


@end
