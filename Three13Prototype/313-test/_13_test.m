//
//  _13_test.m
//  313-test
//
//  Created by Jonathon Rubin on 7/4/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
//

#import "_13_test.h"

@implementation _13_test

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _hand = [[Three13Hand alloc] init];
    
}

- (void)tearDown
{
    // Tear-down code here.
    _hand = nil;

    [super tearDown];
}

- (void)testTwoJokers
{
//    Hand is 2, 3, 4, 5, 5 -- all spades
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.bestScore, 0,
                   @"Best hand score should be 0, as the jokers allow the meld 2, 3, 4, 5-as-5, 5-as-6");

    XCTAssertEqual(self.hand.score, 0,
                   @"Actual hand score should be 0, as the jokers make the meld 2, 3, 4, 5-as-5, 5-as-6");
}

- (void)testHand1
{
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Hearts number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:5]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:6]]; // Joker
    
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.bestScore, 11,
                   @"The best score for this hand is 11 (1,4,6 with meld 6,7,8,9)");
    XCTAssertEqual(self.hand.score, 17,
                   @"The actual score for this hand is 17 (1,4,6,6 with meld 8,9,10(joker)");
}

- (void)testHand2
{
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Clubs number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:12 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:12 suit:Hearts number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:5]];
    
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                   @"This is a winning hand with two jokers");
}
    
- (void)testHand3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:1 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Clubs number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:10 suit:Hearts number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:11 suit:Hearts number:3]];
    
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 1,
                   @"This hand can form a meld of 4 (joker), and 10 and 11 of hearts");
}

- (void)testHandInOrder {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:5]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:6]];
    
    [self.hand evaluateHand];
    XCTAssertEqual(self.hand.score, 29, @"This hand does not get valid runs because they are not in sequential order.");
}

- (void)testHandInPartialOrder {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:1 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:2 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:5]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:6]];
    
    [self.hand evaluateHand];
    XCTAssertEqual(self.hand.score, 20,
                    @"This hand gets 1 valid run for 2-3-4. The rest are not in sequential order.");
}

-(void)testRunInSet1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    NSMutableSet * testSet = [[NSMutableSet alloc] initWithArray:self.hand.cards];
    XCTAssertTrue([self.hand runInSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 5, 6." );
}

-(void)testRunInSet2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    NSMutableSet * testSet = [[NSMutableSet alloc] initWithArray:self.hand.cards];

    XCTAssertTrue([self.hand runInSet:testSet],
                  @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 5, but it is because runInSet doesn't care about card order, and they can form the sequential order 4, 5, 6." );
    
}

-(void)testRunInOrderedSet1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 5, 6." );
}

-(void)testRunInOrderedSet2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 3-as-5, 6." );
}

-(void)testRunInOrderedSet3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has Spades in sequential order 4, 5, 6(joker), 7, 8, 9" );
}

-(void)testRunInOrderedSet4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 4-as-2, 4-as-3, 4-as-4, 5" );
}

-(void)testRunInOrderedSet5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Hearts number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 4-as-2, 4-as-3, 4-as-4, 5, with all the jokers pretending to be hearts" );
}

-(void)testRunInOrderedSet6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 8,9,3-as-10" );
}

-(void)testRunInOrderedSet7 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 8,9,4-as-10,4-as-11" );
    
}

-(void)testRunInOrderedSetReversed1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 6, 5, 4." );
}

- (void)testRunInOrderedSetReversed2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it's got Spades that can form the sequential order 6, 3-as-5, 4." );
}

- (void)testRunInOrderedSetReversed3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has Spades in sequential order 9, 8, 7, 6(joker), 5, 4" );
}

- (void)testRunInOrderedSetReversed4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 5, 4-as-4, 4-as-3, 4-as-2" );
}

- (void)testRunInOrderedSetReversed5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 5, 4-as-4, 4-as-3, 4-as-2, with all the jokers pretending to be hearts" );
}

- (void)testRunInOrderedSetReversed6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 3-as-10,9,8" );
}

- (void)testRunInOrderedSetReversed7 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertTrue([self.hand runInOrderedSet:testSet],
                  @"This set should be a run, because it has cards in sequential order 4-as-11, 4-as-10, 9, 8" );
    

}

-(void)testNoRunInOrderedSet1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                  @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 5." );
}

-(void)testNoRunInOrderedSet2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                  @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 3(joker)." );
}

-(void)testNoRunInOrderedSet3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, but the 6 is a Heart and the rest are Spades." );
}

-(void)testNoRunInOrderedSet4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, 7 but the 7 is a Heart and the rest are Spades, which makes a run of 3 with a spare card...not a run for the whole set." );
}

-(void)testNoRunInOrderedSet5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Hearts number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Hearts number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, 7, 8, 9, but the 7-9 are Hearts and the rest are Spades, making two runs not one for the whole set." );
}

-(void)testNoRunInOrderedSet6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:10 suit:Spades number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, and 8, 9, 10, but there's a gap in the numbering (no 7)." );
}

-(void)testNoRunInOrderedSetReversed1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 5, 6, 4." );
}

-(void)testNoRunInOrderedSetReversed2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 3(joker), 6, 4." );
}

-(void)testNoRunInOrderedSetReversed3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 6, 5, 4, but the 6 is a Heart and the rest are Spades." );
}

-(void)testNoRunInOrderedSetReversed4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 7, 6, 5, 4, but the 7 is a Heart and the rest are Spades, which makes a run of 3 with a spare card...not a run for the whole set." );
}

-(void)testNoRunInOrderedSetReversed5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Hearts number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 9, 8, 7, 6, 5, 4 but the 9-7 are Hearts and the rest are Spades, making two runs not one for the whole set." );
}

-(void)testNoRunInOrderedSetReversed6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:10 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    NSMutableOrderedSet * testSet = [[NSMutableOrderedSet alloc] initWithArray:self.hand.cards];
    
    XCTAssertFalse([self.hand runInOrderedSet:testSet],
                   @"This set shouldn't be a run, because it's got cards in the sequential order 10, 9, 8, and 6, 5, 4, but there's a gap in the numbering (no 7)." );
}

-(void)testScoreOrderedRun1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 5, 6." );
}

-(void)testScoreOrderedRun2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it's got Spades that can form the sequential order 4, 3-as-5, 6." );
}

-(void)testScoreOrderedRun3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has Spades in sequential order 4, 5, 6(joker), 7, 8, 9" );
}

-(void)testScoreOrderedRun4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 4-as-2, 4-as-3, 4-as-4, 5" );
}

-(void)testScoreOrderedRun5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Hearts number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 4-as-2, 4-as-3, 4-as-4, 5, with all the jokers pretending to be hearts" );
}

-(void)testScoreOrderedRun6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 8,9,3-as-10" );
}

-(void)testScoreOrderedRun7 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 8,9,4-as-10,4-as-11" );
}

-(void)testScoreInOrderedRunReversed1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it's got Spades that can form the sequential order 6, 5, 4." );
}

-(void)testScoreInOrderedRunReversed2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it's got Spades that can form the sequential order 6, 3-as-5, 4." );
}

-(void)testScoreInOrderedRunReversed3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has Spades in sequential order 9, 8, 7, 6(joker), 5, 4" );
}

-(void)testScoreInOrderedRunReversed4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 5, 4-as-4, 4-as-3, 4-as-2" );
}

-(void)testScoreInOrderedRunReversed5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 5, 4-as-4, 4-as-3, 4-as-2, with all the jokers pretending to be hearts" );
}

-(void)testScoreInOrderedRunReversed6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 3-as-10,9,8" );
}

-(void)testScoreInOrderedRunReversed7 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                  @"This set should be a run, because it has cards in sequential order 4-as-11, 4-as-10, 9, 8" );
}

-(void)testScoreNoRunInOrderedSet1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 15,
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 5." );
}

-(void)testScoreNoRunInOrderedSet2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 13,
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 4, 6, 3(joker)." );
}

-(void)testScoreNoRunInOrderedSet3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 15,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, but the 6 is a Heart and the rest are Spades." );
}

-(void)testScoreNoRunInOrderedSet4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 7,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, 7 but the 7 is a Heart and the rest are Spades, which makes a run of 3 with a spare card...not a run for the whole set." );
}

-(void)testScoreNoRunInOrderedSet5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Hearts number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Hearts number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, 7, 8, 9, but the 7-9 are Hearts and the rest are Spades, making two runs not one for the whole set." );
}

-(void)testScoreNoRunInOrderedSet6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:10 suit:Spades number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 4, 5, 6, and 8, 9, 10, but there's a gap in the numbering (no 7)." );
}

-(void)testScoreNoRunInOrderedSetReversed1 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 15,
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 5, 6, 4." );
}

-(void)testScoreNoRunInOrderedSetReversed2 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:3 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 13,
                   @"This set shouldn't be a run, because it's got Spades in the nonsequential order 3(joker), 6, 4." );
}

-(void)testScoreNoRunInOrderedSetReversed3 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:2]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 15,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 6, 5, 4, but the 6 is a Heart and the rest are Spades." );
}

-(void)testScoreNoRunInOrderedSetReversed4 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:3]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 7,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 7, 6, 5, 4, but the 7 is a Heart and the rest are Spades, which makes a run of 3 with a spare card...not a run for the whole set." );
}

-(void)testScoreNoRunInOrderedSetReversed5 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Hearts number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Hearts number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:7 suit:Hearts number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 9, 8, 7, 6, 5, 4 but the 9-7 are Hearts and the rest are Spades, making two runs not one for the whole set." );
}

-(void)testScoreNoRunInOrderedSetReversed6 {
    [self.hand clearHand];
    [self.hand addCard:[[Three13Card alloc] initWithValue:10 suit:Spades number:0]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:9 suit:Spades number:1]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:8 suit:Spades number:2]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:6 suit:Spades number:3]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:5 suit:Spades number:4]];
    [self.hand addCard:[[Three13Card alloc] initWithValue:4 suit:Spades number:5]];
    [self.hand evaluateHand];
    
    XCTAssertEqual(self.hand.score, 0,
                   @"This set shouldn't be a run, because it's got cards in the sequential order 10, 9, 8, and 6, 5, 4, but there's a gap in the numbering (no 7)." );
}


@end
