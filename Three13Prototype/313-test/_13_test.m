//
//  _13_test.m
//  313-test
//
//  Created by Jonathon Rubin on 7/4/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
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
    [hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:3]];
    [hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [hand evaluateHand];
    
    XCTAssertEqual(hand.bestScore, 0,
                   @"Best hand score should be 0, as the jokers allow the meld 2, 3, 4, 5-as-5, 5-as-6");

    XCTAssertEqual(hand.score, 0,
                   @"Actual hand score should be 0, as the jokers make the meld 2, 3, 4, 5-as-5, 5-as-6");
}

- (void)testHand1
{
    Three13Hand * testHand1 = [[Three13Hand alloc] init];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:4 suit:Hearts number:1]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:2]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:4]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:5]];
    [testHand1 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:6]]; // Joker
    
    [testHand1 evaluateHand];
    
    XCTAssertEqual(testHand1.bestScore, 11,
                   @"The best score for this hand is 11 (1,4,6 with meld 6,7,8,9)");
    XCTAssertEqual(testHand1.score, 17,
                   @"The actual score for this hand is 17 (1,4,6,6 with meld 8,9,10(joker)");
}

- (void)testHand2
{
    Three13Hand * testHand2 = [[Three13Hand alloc] init];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Clubs number:0]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:1]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:2]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Spades number:3]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:12 suit:Hearts number:4]];
    [testHand2 addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:5]];
    
    [testHand2 evaluateHand];
    
    XCTAssertEqual(testHand2.score, 0,
                   @"This is a winning hand with two jokers");
}
    
- (void)testHand3 {
    Three13Hand * testHand3 = [[Three13Hand alloc] init];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:1 suit:Hearts number:0]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:4 suit:Clubs number:1]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:10 suit:Hearts number:2]];
    [testHand3 addCard:[[Three13Card alloc] initWithValue:11 suit:Hearts number:3]];
    
    [testHand3 evaluateHand];
    
    XCTAssertEqual(testHand3.score, 1,
                   @"This hand can form a meld of 4 (joker), and 10 and 11 of hearts");
}

- (void)testHandInOrder {
    Three13Hand * testHand = [[Three13Hand alloc] init];
    [testHand addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [testHand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [testHand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [testHand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:3]];
    [testHand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:4]];
    [testHand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:5]];
    [testHand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:6]];
    
    [testHand evaluateHand];
    XCTAssertEqual(testHand.score, 29, @"This hand does not get valid runs because they are not in sequential order.");
}

- (void)testHandInPartialOrder {
    Three13Hand * testHand = [[Three13Hand alloc] init];
    [testHand addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [testHand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [testHand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:2]];
    [testHand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:3]];
    [testHand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:4]];
    [testHand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:5]];
    [testHand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:6]];
    
    [testHand evaluateHand];
    XCTAssertEqual(testHand.score, 20,
                    @"This hand gets 1 valid run for 2-3-4. The rest are not in sequential order.");
}

- (void)testRunInSet {
    NSMutableSet * testSet = [[NSMutableSet alloc] init];
    [testSet addObject:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [testSet addObject:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [testSet addObject:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    Three13Hand * testHand = [[Three13Hand alloc] init];
    XCTAssertTrue([testHand runInSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 5, 6." );
    
    testSet = [[NSMutableSet alloc] init];
    [testSet addObject:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [testSet addObject:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [testSet addObject:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];

    XCTAssertTrue([testHand runInSet:testSet],
                  @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 5, but it is because runInSet doesn't care about card order, and they can form the sequential order 4, 5, 6." );
    
}

- (void)testRunInOrderedSet {
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] init];
    [testSet addObject:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [testSet addObject:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [testSet addObject:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    Three13Hand * testHand = [[Three13Hand alloc] init];
    XCTAssertTrue([testHand runInOrderedSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 5, 6." );
    
    testSet = [[NSMutableOrderedSet alloc] init];
    [testSet addObject:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [testSet addObject:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [testSet addObject:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    
    XCTAssertFalse([testHand runInOrderedSet:testSet],
                  @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 5." );
    
}

@end
