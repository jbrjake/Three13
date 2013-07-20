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
        _handMeld = [TTTMeldNode nodeWithColor:[SKColor lightGrayColor] andSize:CGSizeMake(175, 175)];
        
        _meld1 = [TTTMeldNode nodeWithColor:[SKColor lightGrayColor] andSize:CGSizeMake(125, 125)];

        _meld2 = [TTTMeldNode nodeWithColor:[SKColor lightGrayColor] andSize:CGSizeMake(125, 125)];
    
        _meld3 = [TTTMeldNode nodeWithColor:[SKColor lightGrayColor] andSize:CGSizeMake(125, 125)];
        
        _meld4 = [TTTMeldNode nodeWithColor:[SKColor lightGrayColor] andSize:CGSizeMake(125, 125)];
        
        [self setMeldLocations];
        [self addChild:self.handMeld];
        [self addChild:self.meld1];
        [self addChild:self.meld2];
        [self addChild:self.meld3];
        [self addChild:self.meld4];
        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:2.5];
//        [self.handMeld runAction:[SKAction repeatActionForever:action]];

        [self dealHand];
    }
    return self;
}

-(void) setMeldLocations {
    self.handMeld.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.meld1.position = CGPointMake(self.frame.size.width - 75, self.frame.size.height - 75);
    self.meld2.position = CGPointMake(75, self.frame.size.height - 75);
    self.meld3.position = CGPointMake(self.frame.size.width - 75, 75);
    self.meld4.position = CGPointMake(75, 75);
}

-(void) dealHand {
    TTTCardSpriteNode * cyanSprite = [TTTCardSpriteNode nodeWithColor:[SKColor cyanColor] andSize:CGSizeMake(44,44)andVertices:3];
    TTTCardSpriteNode * magentaSprite = [TTTCardSpriteNode nodeWithColor:[SKColor magentaColor] andSize:CGSizeMake(44,44)andVertices:4];
    TTTCardSpriteNode * yellowSprite = [TTTCardSpriteNode nodeWithColor:[SKColor yellowColor] andSize:CGSizeMake(44,44)andVertices:5];
    TTTCardSpriteNode * blackSprite = [TTTCardSpriteNode nodeWithColor:[SKColor blackColor] andSize:CGSizeMake(44,44)andVertices:6];
    
    [self.handMeld addChild:cyanSprite];
    [self.handMeld addChild:magentaSprite];
    [self.handMeld addChild:yellowSprite];
    [self.handMeld addChild:blackSprite];
/*
    SKAction *action = [SKAction rotateByAngle:M_PI duration:2.5];
    [cyanSprite runAction:[SKAction repeatActionForever:action]];
    [magentaSprite runAction:[SKAction repeatActionForever:action]];
    [yellowSprite runAction:[SKAction repeatActionForever:action]];
    [blackSprite runAction:[SKAction repeatActionForever:action]];
*/
    [self.handMeld positionCards];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if (self.handMeld.children.count == 14) {
        return;
    }
    
    NSArray * colors = @[ [SKColor cyanColor], [SKColor magentaColor], [SKColor yellowColor], [SKColor blackColor] ];
    for (UITouch *touch in touches) {
        
        TTTCardSpriteNode * sprite = [TTTCardSpriteNode nodeWithColor:colors[rand()%4] andSize:CGSizeMake(44,44)andVertices:rand()%11+3];
        SKAction *action = [SKAction rotateByAngle:M_PI duration:2.5];
        
      //  [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self.handMeld addChild:sprite];
        [self.handMeld positionCards];
    }
/*
    NSInteger childCount = self.handMeld.children.count;
    NSInteger pos1 = rand()%childCount;
    NSInteger pos2 = rand()%childCount;
    TTTCardSpriteNode * card1 = self.handMeld.children[pos1];
    TTTCardSpriteNode * card2 = self.handMeld.children[pos2];
    [self.handMeld removeChildrenInArray:@[card1, card2]];
    if (pos1 == childCount-1) {
        pos1--;
    }
    if (pos2 == childCount-1) {
        pos2--;
    }
    [self.handMeld insertChild:card2 atIndex:pos1];
    [self.handMeld insertChild:card1 atIndex:pos2];
    [self.handMeld positionCards];
*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
