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

- (void)testHand1
{
    Three13Hand * testHand1 = [[Three13Hand alloc] init];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:4 suit:Hearts number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];
    
    [testHand1 evaluateHand];
    
    STAssertEquals(testHand1.score, 11, @"The best score for this hand is 11");
}

- (void)testHand2
{
    Three13Hand * testHand2 = [[Three13Hand alloc] init];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Clubs number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Spades number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Hearts number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    
    [testHand2 evaluateHand];
    
    STAssertEquals(testHand2.score, 0, @"This is a winning hand with two jokers");
}
    
- (void)testHand3 {
    Three13Hand * testHand3 = [[Three13Hand alloc] init];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:1 suit:Hearts number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:4 suit:Clubs number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:10 suit:Hearts number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:11 suit:Hearts number:0]];
    
    [testHand3 evaluateHand];
    
    STAssertEquals(testHand3.score, 1, @"This hand can form a meld of 4 (joker), and 10 and 11 of hearts");
}

@end
