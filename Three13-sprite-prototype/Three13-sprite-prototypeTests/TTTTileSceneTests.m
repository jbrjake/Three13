//
//  TTTTileSceneTests.m
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 8/1/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TTTTileScene.h"
#import "TTTTileSprite.h"

@interface TTTTileSceneTests : XCTestCase

@end

@implementation TTTTileSceneTests

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

- (void)testInitWith16x9Size {
    CGFloat width = 320;
    CGFloat height = 568;
    
    TTTTileScene * scene = [[TTTTileScene alloc] initWithSize:CGSizeMake(width, height)];
    
    
    XCTAssertEqual(scene.size.width, width, @"Width for 16x9 iPhone should be %f", width);
    XCTAssertEqual(scene.size.height, height, @"Height for 16x9 iPhone should be %f", height);
    
}

-(void) testDealHand {
    CGFloat width = 320;
    CGFloat height = 568;
    
    TTTTileScene * scene = [[TTTTileScene alloc] initWithSize:CGSizeMake(width, height)];
    
    CGFloat cellSize = scene.frame.size.height/10.0;
    TTTTileSprite * cyanSprite = [TTTTileSprite nodeWithColor:[SKColor cyanColor] andSize:CGSizeMake(cellSize,cellSize)andVertices:3];
    TTTTileSprite * magentaSprite = [TTTTileSprite nodeWithColor:[SKColor magentaColor] andSize:CGSizeMake(cellSize,cellSize)andVertices:4];
    TTTTileSprite * yellowSprite = [TTTTileSprite nodeWithColor:[SKColor yellowColor] andSize:CGSizeMake(cellSize,cellSize)andVertices:5];
    TTTTileSprite * blackSprite = [TTTTileSprite nodeWithColor:[SKColor blackColor] andSize:CGSizeMake(cellSize,cellSize)andVertices:6];
    cyanSprite.name = @"Cyan";
    magentaSprite.name = @"Magenta";
    yellowSprite.name = @"Yellow";
    blackSprite.name = @"Black";
    [scene addChild:cyanSprite];
    [scene addChild:magentaSprite];
    [scene addChild:yellowSprite];
    [scene addChild:blackSprite];
    [scene addTileSprite:cyanSprite];
    [scene addTileSprite:magentaSprite];
    [scene addTileSprite:yellowSprite];
    [scene addTileSprite:blackSprite];
    [scene layoutTiles];
    
    XCTAssert(scene.placedTiles.count == 4, @"There should be 4 tiles placed at this point");
}

@end
