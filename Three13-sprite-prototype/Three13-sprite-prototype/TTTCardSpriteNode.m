//
//  TTTCardSpriteNode.m
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 6/13/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import "TTTCardSpriteNode.h"

@implementation TTTCardSpriteNode


+ (TTTCardSpriteNode*) nodeWithColor:(SKColor*)color andSize:(CGSize)size andVertices:(NSInteger)vertices {
    TTTCardSpriteNode * node = [[TTTCardSpriteNode alloc] initWithColor:color andSize:size andVertices:vertices];
    return node;
}

- (TTTCardSpriteNode*) initWithColor:(SKColor*)color andSize:(CGSize)size andVertices:(NSInteger)vertices {
    self = [super initWithColor:color size:size];
    if (self) {
        _vertices = [NSNumber numberWithInteger:vertices];
        [self buildShapePaths];
        self.texture = [self textureWithColor:color andVertices:vertices andSize:size];
    }
    return self;
}

- (SKTexture *)textureWithColor:(SKColor*)color andVertices:(NSInteger)vertices andSize:(CGSize)size {
    SKTexture * texture = nil;
    CGImageRef imageRef = [self imageRefWithColor:color andVertices:vertices andSize:size];;
    texture = [SKTexture textureWithCGImage:imageRef];
    return texture;
}

- (CGImageRef)imageRefWithColor:(SKColor*)color andVertices:(NSInteger)vertices andSize:(CGSize)size {
    CGImageRef imageRef = NULL;
    
    CGFloat imageScale = (CGFloat)2.0;
    
    CGColorRef cgColor = color.CGColor;
    const CGFloat * colorComponents = CGColorGetComponents(cgColor);

    // Create a bitmap graphics context of the given size
    //
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(size, NO, imageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw ...
    //
    CGContextSetRGBFillColor(context, colorComponents[0], colorComponents[1], colorComponents[2], (CGFloat)1.0 );
    
    // Draw a circle
    CGContextAddPath(context, self.circlePath);

    // Draw an n-sided polygon
    
    CGContextAddPath(context, self.polygonPath);

    // Draw lines from the polygon's vertices to the center
    CGContextSetRGBStrokeColor(context, colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]);
    CGContextSetLineWidth(context, 2.0);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextAddPath(context, self.verticesPath);

    CGContextSetRGBStrokeColor(context, colorComponents[0] , colorComponents[1], colorComponents[2], 1);
    CGContextSetLineWidth(context, 1);
    CGContextDrawPath(context, kCGPathFillStroke);

    // Get your image
    //
    imageRef = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return imageRef;
}

-(void)buildShapePaths {
    // Draw a circle
    _circlePath = CGPathCreateMutable();
    
    CGPathAddArc(self.circlePath, NULL, self.size.width/2, self.size.width/2, self.size.width/2*0.9, 0, 2*M_PI, YES);

    CGPathCloseSubpath(self.circlePath);
    
    // Draw a polygon
    _polygonPath = CGPathCreateMutable();
    
    int radius = MIN(self.size.width, self.size.height)*0.33 ;
    
    NSMutableArray * verticePoints = [NSMutableArray array];
    for (int i = 0; i < self.vertices.integerValue; i++){
        
        CGPoint point = CGPointMake( (self.size.width/2) + (radius * cosf(i*2*M_PI/self.vertices.integerValue)), (self.size.width/2) + (radius*sinf(i*2*M_PI/ self.vertices.integerValue)) );
        
        [verticePoints addObject:[NSValue valueWithCGPoint:point]];
        
        if (i==0) {
            CGPathMoveToPoint(self.polygonPath, NULL, point.x, point.y);
        }
        else{
            CGPathAddLineToPoint(self.polygonPath, NULL, point.x, point.y);
        }
        
    }
    CGPathCloseSubpath(self.polygonPath);

    // Draw vertex lines
    _verticesPath = CGPathCreateMutable();
    
    for (NSValue* pointValue in verticePoints) {
        CGPoint point = [pointValue CGPointValue];
        CGPathMoveToPoint(self.verticesPath, NULL, point.x, point.y);
        CGPathAddLineToPoint(self.verticesPath, NULL, self.size.width/2, self.size.width/2);
    }
    CGPathCloseSubpath(self.verticesPath);

    
}

@end
