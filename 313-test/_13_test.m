//
//  _13_test.m
//  313-test
//
//  Created by Jonathon Rubin on 7/4/12.
//  Copyright (c) 2012 The Nielsen Company. All rights reserved.
//

#import "_13_test.h"
#import "Three13Hand.h"

@implementation _13_test

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testTwoJokers
{
    Three13Hand * hand = [[Three13Hand alloc] init];
//    Hand is 2, 3, 4, 5, 5 -- all spades
    [hand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:0]];
    [hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:0]];
    [hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [hand evaluateHand];
    
    STAssertEquals(hand.score, 0, @"Hand score should be 0, as the jokers allow the meld 2, 3, 4, 5-as-5, 5-as-6");
}

@end
