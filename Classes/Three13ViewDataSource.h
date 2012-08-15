//
//  Three13ViewDataSource.h
//  313-prototype
//
//  Created by Jonathon Rubin on 7/6/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 * @brief Informs the data source that the user is selecting a card to add to the hand
 * @param tag The ID of the card the user is selecting
 */
-(void) selectCardWith:(NSInteger)tag;

/*
 * @brief Informs the data source that the user is selecting a card to discard from the hand
 * @param tag The ID of the card the user is discarding
 */
-(void) discardCardWith:(NSInteger)tag;

@end
