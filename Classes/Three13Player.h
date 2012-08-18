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

@property (nonatomic,strong) Three13Hand * hand;

/*
 * @brief The score for the current hand, if someone went out right now
 */
@property (nonatomic) NSInteger currentScore;

/*
 * @brief The score accumulated across all previous levels, not including the current score
 */
@property (nonatomic) NSInteger totalScore;

-(void) checkForWin;

@end
