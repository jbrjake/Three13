//
//  TTTMyScene.m
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 6/13/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import "TTTMyScene.h"
#import "TTTCardSpriteNode.h"
#import "TTTMeldNode.h"

@implementation TTTMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        _spriteCells = [[NSMutableArray alloc] init];
        _placedTiles = [[NSMutableArray alloc] init];
        
        CGFloat height = self.frame.size.height;
        CGFloat centerX = self.frame.size.width/2.0;
        CGFloat cellHeight = height/10.0;
        
        // Cells 0-12
        for (int i = 0; i < 10; i++) {
            if (i % 2 ) {
                [self.spriteCells addObject:
                    [NSValue valueWithCGPoint:
                        CGPointMake(centerX - cellHeight,
                                    cellHeight/2 + i * cellHeight)]];
                [self.spriteCells addObject:
                    [NSValue valueWithCGPoint:
                        CGPointMake(centerX + cellHeight,
                                    cellHeight/2 + i * cellHeight)]];
            }
            else {
                [self.spriteCells addObject:
                    [NSValue valueWithCGPoint:
                        CGPointMake(centerX,
                                    cellHeight/2 + i * cellHeight)]];
            }
        }
        
    }
    
    [self dealHand];
    return self;
}

-(void) dealHand {
    TTTCardSpriteNode * cyanSprite = [TTTCardSpriteNode nodeWithColor:[SKColor cyanColor] andSize:CGSizeMake(44,44)andVertices:3];
    TTTCardSpriteNode * magentaSprite = [TTTCardSpriteNode nodeWithColor:[SKColor magentaColor] andSize:CGSizeMake(44,44)andVertices:4];
    TTTCardSpriteNode * yellowSprite = [TTTCardSpriteNode nodeWithColor:[SKColor yellowColor] andSize:CGSizeMake(44,44)andVertices:5];
    TTTCardSpriteNode * blackSprite = [TTTCardSpriteNode nodeWithColor:[SKColor blackColor] andSize:CGSizeMake(44,44)andVertices:6];
    

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        CGPoint spriteLocation = [self.scene convertPointFromView:touchLocation];
        NSArray * nodes = [self.scene nodesAtPoint:spriteLocation];
        int cellIndex = [self indexOfClosestCellToPoint:spriteLocation];
        for (id node in nodes) {
            if([node isKindOfClass:[TTTCardSpriteNode class]]) {
                self.heldTile = node;
                self.heldTile.zPosition = -1;
                self.heldTile.alpha = 0.5;
                self.heldCellIndex = cellIndex;
                self.touchStartLocation = touchLocation;
                self.heldStartPosition = [self.spriteCells[[self.placedTiles indexOfObject:node]] CGPointValue];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.heldTile) {
        UITouch *touch = [touches anyObject];
        UIView *view = self.view;
        CGPoint location = [touch locationInView:view];
        [self moveHeldTileToPoint:location];
    }
}

 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
     [self touchesEnded:touches withEvent:event];
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
     for (UITouch * touch in touches) {
         CGPoint touchLocation = [touch locationInView:self.view];
         CGPoint spriteLocation = [self.scene convertPointFromView:touchLocation];
         int cellIndex = [self indexOfClosestCellToPoint:spriteLocation];
         [self exchangeTileAtCell:self.heldCellIndex withTileAtCell:cellIndex];
         [self layoutTiles];
         self.heldTile.alpha = 1.0;
         self.heldTile.zPosition = 0;
         self.heldTile = nil;
     }
 }
 
# pragma mark  TileSpriteControllDelegate (informal)

// Places a sprite at the next available cell
- (void)addTileSprite:(SKSpriteNode*)sprite {
    [self.placedTiles addObject:sprite];
}

// Places a sprite at a particular cell
- (void)addTileSprite:(SKSpriteNode*)sprite toCellWithIndex:(NSInteger)index {
    [self.placedTiles insertObject:sprite atIndex:index];
}

// Removes a sprite from its frame cell
- (void)removeTileSprite:(SKSpriteNode*)sprite {
    [self.placedTiles removeObject:sprite];
}

// Swaps the sprites in two different cells
- (void) exchangeTileAtCell:(NSInteger)indexA withTileAtCell:(NSInteger)indexB {
    [self.placedTiles exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
}

// Positions all tiles in their cells
- (void)layoutTiles {
    int i = 0;
    for (SKSpriteNode * tile in self.placedTiles) {        
        [tile runAction:[SKAction moveTo:[self.spriteCells[i] CGPointValue] duration:0.1]];
        i++;
    }
}

// Returns the cell frame index for a sprite
- (NSInteger)cellIndexForTileSprite:(SKSpriteNode*)sprite {
    int retValue = -1;
    
    for (NSValue *positionValue in self.spriteCells) {
        CGPoint position = [positionValue CGPointValue];
        if ((CGPointEqualToPoint(position, sprite.position))) {
            retValue = [self.spriteCells indexOfObject:positionValue];
        }
    }
    return retValue;
}

// Returns the tile located within a given cell frame index
- (SKSpriteNode*)tileForCellIndex:(NSInteger)index {
    SKSpriteNode *returnNode = nil;
    CGPoint position = [self.spriteCells[index] CGPointValue];
    NSArray * nodes = [self.scene nodesAtPoint:position];
    for (id node in nodes) {
        if([node isKindOfClass:[TTTCardSpriteNode class]]) {
            returnNode = node;
        }
    }
    return returnNode;
}

// Moves the tile being touched by the user to the touch location
- (void)moveHeldTileToPoint:(CGPoint)location {
    float dx = location.x - self.touchStartLocation.x;
    float dy = location.y - self.touchStartLocation.y;
    CGPoint newPosition = CGPointMake(self.heldStartPosition.x + dx, self.heldStartPosition.y - dy);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.heldTile.position = newPosition;
    [CATransaction commit];
}

// Returns the closest cell to a position in the scene
- (int)indexOfClosestCellToPoint:(CGPoint)point {
    int index = 0;
    CGFloat minDist = FLT_MAX;
    for (int i = 0; i < self.placedTiles.count; i++) {
        CGPoint position = [self.spriteCells[i] CGPointValue];
        
        CGFloat dx = point.x - position.x;
        CGFloat dy = point.y - position.y;
            
        CGFloat dist = (dx * dx) + (dy * dy);
        if (dist < minDist) {
            index = i;
            minDist = dist;
        }
    }
    return index;
}

@end
