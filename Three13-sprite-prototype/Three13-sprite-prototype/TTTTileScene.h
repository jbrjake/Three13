//
//  TTTMyScene.h
//  Three13-sprite-prototype
//

//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class TTTMeldNode;

@interface TTTTileScene : SKScene

@property NSMutableArray * spriteCells;
@property NSMutableArray * placedTiles;
@property SKSpriteNode * heldTile;
@property int heldCellIndex;
@property CGPoint heldStartPosition;
@property CGPoint touchStartLocation;

- (void)addTileSprite:(SKSpriteNode*)sprite;
- (void)addTileSprite:(SKSpriteNode*)sprite toCellWithIndex:(NSInteger)index;
- (void)removeTileSprite:(SKSpriteNode*)sprite;
- (void)exchangeTileAtCell:(NSInteger)indexA withTileAtCell:(NSInteger)indexB;
- (void)layoutTiles;

// These should move to a class extension, instead of being exposed as public methpds:
// http://lisles.net/accessing-private-methods-and-properties-in-objc-unit-tests/
- (NSInteger)cellIndexForTileSprite:(SKSpriteNode*)sprite;
- (SKSpriteNode*)tileForCellIndex:(NSInteger)index;
- (void)moveHeldTileToPoint:(CGPoint)location;
- (int)indexOfClosestCellToPoint:(CGPoint)point;

@end
