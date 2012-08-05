//
//  Three13GameDelegate.h
//  313-prototype
//
//  Created by Jonathon Rubin on 7/6/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Three13GameDelegate <NSObject>

/*
 * @brief Informs the delegate the game has begun
 * When the delegate view controller has finished responding
 * (perhaps by animating the game view into place),
 * it must run the provided completion handler.
 * This way, the start of the game does not flow immediately into the first round.
 * @param completionHandler A block the delegate is responsible for calling once it is ready for the game to proceed
 */
- (void) respondToStartOfGameWithCompletionHandler:(void (^)())completionHandler;

/*
 * @brief Informs the delegate a level has begun
 * The delegate view controller should respond to the event
 * asynchronously and return right away.
 * @param dict The current game state, from Three13Game's gameDict: method
 */
- (void) respondToStartOfLevelWithDictionary:(NSMutableDictionary*)dict;

/*
 * @brief Informs the delegate a round has begun
 * The delegate view controller should respond to the event
 * asynchronously and return right away.
 * @param dict The current game state, from Three13Game's gameDict: method
 */
- (void) respondToStartOfRoundWithDictionary:(NSMutableDictionary*)dict;

/*
 * @brief Informs the delegate a known card has been selected
 * The delegate view controller should respond to the event
 * asynchronously and return right away.
 * @param dict The current game state, from Three13Game's gameDict: method
 */
- (void) respondToKnownCardChosenWithDictionary:(NSMutableDictionary*)dict;

/*
 * @brief Informs the delegate a mystery card has been selected
 * The delegate view controller should respond to the event
 * asynchronously and return right away.
 * @param dict The current game state, from Three13Game's gameDict: method
 */
- (void) respondToMysteryCardChosenWithDictionary:(NSMutableDictionary*)dict;

/*
 * @brief Informs the delegate a level has ended
 * When the delegate view controller has finished responding
 * (perhaps by animating the cards off screen and displaying the current score),
 * it must run the provided completion handler.
 * This way, the end of one level does not flow immediately into the start of the next.
 * @param dict The current game state, from Three13Game's gameDict: method
 * @param completionHandler A block the delegate is responsible for calling once it is ready for the next level to proceed
 */
- (void) respondToEndOfLevelWithDictionary:(NSMutableDictionary*)dict andCompletionHandler:(void (^)())completionHandler;

/*
 * @brief Informs the delegate a card has been discarded (i.e. the round is over)
 * When the delegate view controller has finished responding
 * (perhaps by animating the discarded card to the discard pile),
 * it must run the provided completion handler.
 * This way, the end of one round does not flow immediately into the start of the next.
 * @param dict The current game state, from Three13Game's gameDict: method
 * @param completionHandler A block the delegate is responsible for calling once it is ready for the next round to proceed
 */
- (void) respondToCardBeingDiscardedWithDictionary:(NSMutableDictionary*)dict andCompletionHandler:(void (^)())completionHandler;

@end
