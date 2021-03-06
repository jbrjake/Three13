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

/**
 * @brief Lets the VC tell the model to start a game
 */
-(void) startGame;

/**
 * @brief Accessor for the cards in the deck (not yet played)
 * @return An NSMutableArray containing the cards still in the deck
 */
-(NSMutableArray * ) cardsInDeck;

/**
 * @brief Accessor for all the cards, including ones played
 * @return An NSMutableArray containing all cards in the game
 */
-(NSMutableArray*) allCards;

/**
 * @brief Informs the data source that the user is selecting a card to add to the hand or discard
 * @param tag The ID of the card the user is selecting
 * @param index The index of the player in the players array who is selecting the card
 */
-(void) selectCardWith:(NSInteger)tag byPlayerWithIndex:(NSInteger)index;

/**
 * @brief Accessor for the score of a player in the current round
 * This is the score the player would have if he or she were forced to lay cards on the table right now.
 * @param index The index of the player, in the data source's players array.
 */
-(NSInteger) currentScoreForPlayerWithIndex:(NSInteger)index;

/**
 * @brief Accessor for the total score of a player so far in the game
 * This is the "real" score, as it includes only points already assessed in the game. It does not include the current score.
 * @param index The index of the player, in the data source's players array.
 */
-(NSInteger) totalScoreForPlayerWithIndex:(NSInteger)index;

/**
 * @brief The current level
 */
@property (nonatomic) NSInteger level;

/**
 * @brief The current round of the current level, which never exceeds the level (level 3 has 3 rounds, level 4 has 4 rounds, etc)
 */
@property (nonatomic) NSInteger round;

/**
 * @brief An array containing the players in the game
 */
@property (nonatomic, strong) NSMutableArray * players;

/**
 * @brief The index of the current player in the players array
 */
@property (nonatomic) NSInteger currentPlayer;

/**
 * @brief The card available for selection from the discard pile. It's known because it's face up.
 */
@property (nonatomic, strong) Three13Card * knownCard;

/**
 * @brief The card available for selection from the deck. It's a mystery because it's face down.
 */
@property (nonatomic, strong) Three13Card * mysteryCard;

@end
