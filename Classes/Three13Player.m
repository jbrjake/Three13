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

// I need to set this to return a BOOL and do most of the else in the game object itself
// -1 = keep going
//  0 = out of rounds loss
//  1 = win
-(int) checkForWinWith:(NSMutableDictionary *)dict {
    //First check for going out
    //Then check for out of time
    
    int ret = -1;
    
    [hand updateScore];
    [self setCurrentScore:hand.score];
    if (hand.score == 0) {
        //        NSLog(@"It's a win!");
        ret = 1;
    }
    else if( [[dict objectForKey:@"round"] intValue] > [[dict objectForKey:@"level"]intValue]-1 ) {
        //       NSLog(@"Out of rounds!");
        ret = 0;
    }
    
    return ret;
}


@end
