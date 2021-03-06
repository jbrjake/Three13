//
//  Three13Player.h
//  313-prototype
//
//  Created by Jonathon Rubin on 8/17/12.
//
//

#import <Foundation/Foundation.h>
#import "Three13Hand.h"

@interface Three13Player : NSObject {
    Three13Hand * hand;
    NSInteger state;
    NSInteger currentScore;
    NSInteger totalScore;
}

/**
 * @brief The player's game state
 * * -1: Waiting for turn
 * *  0: Selecting card
 * *  1: Discarding card
 * *  2: Out (reached 0 points for the level)
 */
@property (nonatomic) NSInteger state;

@property (nonatomic,strong) Three13Hand * hand;

/**
 * @brief The score for the current hand, if someone went out right now
 */
@property (nonatomic) NSInteger currentScore;

/**
 * @brief The score accumulated across all previous levels, not including the current score
 */
@property (nonatomic) NSInteger totalScore;

-(int) checkForWinWith:(NSMutableDictionary *)dict;

@end
