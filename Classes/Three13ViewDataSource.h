//
//  Three13ViewDataSource.h
//  313-prototype
//
//  Created by Jonathon Rubin on 7/6/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Three13Card;

@protocol Three13ViewDataSource <NSObject>

/*
 * @brief Lets the VC tell the model to start a game
 */
-(void) startGame;

/*
 * @brief Accessor for the cards in the deck (not yet played)
 * @return An NSMutableArray containing the cards still in the deck
 */
-(NSMutableArray * ) cardsInDeck;

/*
 * @brief Accessor for all the cards, including ones played
 * @return An NSMutableArray containing all cards in the game
 */
-(NSMutableArray*) allCards;

/*
 * @brief Informs the data source that the user is selecting a card to add to the hand or discard
 * @param tag The ID of the card the user is selecting
 */
-(void) selectCardWith:(NSInteger)tag;

/*
 * @brief The score for the current hand, if someone went out right now
 */
@property (nonatomic) NSInteger currentScore;

/*
 * @brief The score accumulated across all previous levels, not including the current score
 */
@property (nonatomic) NSInteger totalScore;

/*
 * @brief The current level
 */
@property (nonatomic) NSInteger level;

/*
 * @brief The current round of the current level, which never exceeds the level (level 3 has 3 rounds, level 4 has 4 rounds, etc)
 */
@property (nonatomic) NSInteger round;

/*
 * @brief The card available for selection from the discard pile. It's known because it's face up.
 */
@property (nonatomic, strong) Three13Card * knownCard;

/*
 * @brief The card available for selection from the deck. It's a mystery because it's face down.
 */
@property (nonatomic, strong) Three13Card * mysteryCard;

@end
