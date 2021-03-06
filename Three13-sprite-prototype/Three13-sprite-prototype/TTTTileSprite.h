//
//  TTTCardSpriteNode.h
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 6/13/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TTTTileSprite : SKSpriteNode

+ (TTTTileSprite*) nodeWithColor:(SKColor*)color andSize:(CGSize)size andVertices:(NSInteger)vertices;

@property CGMutablePathRef circlePath;
@property CGMutablePathRef polygonPath;
@property CGMutablePathRef verticesPath;
@property NSNumber * vertices;
@end
