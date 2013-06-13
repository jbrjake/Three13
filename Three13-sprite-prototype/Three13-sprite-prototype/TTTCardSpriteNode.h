//
//  TTTCardSpriteNode.h
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 6/13/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TTTCardSpriteNode : SKSpriteNode

+ (TTTCardSpriteNode*) nodeWithColor:(SKColor*)color andSize:(CGSize)size andVertices:(NSInteger)vertices;

@end
