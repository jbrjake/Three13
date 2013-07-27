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
        CGFloat height = self.frame.size.height;
        CGFloat centerX = self.frame.size.width/2.0;
        CGFloat cellHeight = height/10.0;
        
        // Cells 0-12
        for (int i = 0; i < 9; i++) {
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
    /* Called when a touch begins */

    NSArray * colors = @[ [SKColor cyanColor], [SKColor magentaColor], [SKColor yellowColor], [SKColor blackColor] ];
    for (UITouch *touch in touches) {
        
        TTTCardSpriteNode * sprite = [TTTCardSpriteNode nodeWithColor:colors[rand()%4] andSize:CGSizeMake(44,44)andVertices:rand()%11+3];
        SKAction *action = [SKAction rotateByAngle:M_PI duration:2.5];
        
      //  [sprite runAction:[SKAction repeatActionForever:action]];
        
    }
}

 - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
 
 }
 
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
 }
 
 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 
 }

@end
