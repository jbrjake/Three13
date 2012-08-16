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

@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSInteger totalScore;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger round;
@property (nonatomic, strong) Three13Card * knownCard;
@property (nonatomic, strong) Three13Card * mysteryCard;

@end
