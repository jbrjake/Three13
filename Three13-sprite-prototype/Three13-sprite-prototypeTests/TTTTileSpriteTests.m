//
//  TTTTileSpriteTests.m
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 8/1/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTTTileSprite.h"

@interface TTTTileSpriteTests : XCTestCase

@end

@implementation TTTTileSpriteTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTileSpriteInit
{
    CGFloat tileWidth = 44;
    CGFloat tileHeight = 44;
    int tileNumber = 9;
    SKColor * color = [SKColor cyanColor];
    TTTTileSprite * tile = [TTTTileSprite nodeWithColor:color
                                                andSize:CGSizeMake(tileWidth, tileHeight)
                                            andVertices:tileNumber];
    XCTAssert(tile,
              @"The tile should exist.");
    XCTAssert([tile.color isEqual:[SKColor cyanColor]],
                   @"The tile's color should be cyan");
    XCTAssertEqual(tile.size.width, tileWidth,
                   @"The tile's width should be %f", tileWidth);
    XCTAssertEqual(tile.size.height, tileHeight,
                   @"The tile's height should be %f", tileHeight);
    XCTAssertEqual(tile.vertices, [NSNumber numberWithInt:tileNumber],
                   @"The tile's vertex count should be %d", tileNumber);
    
    SKLabelNode * tileLabel = tile.children[0];
    NSString * text = tileLabel.text;
    NSString * tileNumberText = [NSString stringWithFormat:@"%d", tileNumber];
    XCTAssertTrue([text isEqualToString:tileNumberText],
                  @"The tile's text should be %@, because the vertext count is %d", tileNumberText, tileNumber);
}

@end
