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

        [self dealHand];
    }
    return self;
}

-(void) dealHand {
    TTTCardSpriteNode * cyanSprite = [TTTCardSpriteNode nodeWithColor:[SKColor cyanColor] andSize:CGSizeMake(44,44)andVertices:3];
    TTTCardSpriteNode * magentaSprite = [TTTCardSpriteNode nodeWithColor:[SKColor magentaColor] andSize:CGSizeMake(44,44)andVertices:4];
    TTTCardSpriteNode * yellowSprite = [TTTCardSpriteNode nodeWithColor:[SKColor yellowColor] andSize:CGSizeMake(44,44)andVertices:5];
    TTTCardSpriteNode * blackSprite = [TTTCardSpriteNode nodeWithColor:[SKColor blackColor] andSize:CGSizeMake(44,44)andVertices:6];
    

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

    NSArray * colors = @[ [SKColor cyanColor], [SKColor magentaColor], [SKColor yellowColor], [SKColor blackColor] ];
    for (UITouch *touch in touches) {
        
        TTTCardSpriteNode * sprite = [TTTCardSpriteNode nodeWithColor:colors[rand()%4] andSize:CGSizeMake(44,44)andVertices:rand()%11+3];
        SKAction *action = [SKAction rotateByAngle:M_PI duration:2.5];
        
      //  [sprite runAction:[SKAction repeatActionForever:action]];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
