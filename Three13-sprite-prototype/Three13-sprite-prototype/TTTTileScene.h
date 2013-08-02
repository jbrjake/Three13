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

@end
