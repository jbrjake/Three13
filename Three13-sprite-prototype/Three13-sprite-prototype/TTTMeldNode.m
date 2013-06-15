//
//  TTTMeldNode.m
//  Three13-sprite-prototype
//
//  Created by Jonathon Rubin on 6/13/13.
//  Copyright (c) 2013 Jonathon Rubin. All rights reserved.
//

#import "TTTMeldNode.h"

@implementation TTTMeldNode

+ (TTTMeldNode*) nodeWithColor:(SKColor*)color andSize:(CGSize)size {
    TTTMeldNode * node = [[TTTMeldNode alloc] initWithColor:color andSize:size];
    return node;
}

- (TTTMeldNode*) initWithColor:(SKColor*)color andSize:(CGSize)size {
    self = [super initWithColor:color size:size];
    if (self) {
        self.texture = [self textureWithColor:color andSize:size];
    }
    return self;
}

- (SKTexture *)textureWithColor:(SKColor*)color andSize:(CGSize)size {
    SKTexture * texture = nil;
    CGImageRef imageRef = [self imageRefWithColor:color andSize:size];;
    texture = [SKTexture textureWithCGImage:imageRef];
    return texture;
}

- (CGImageRef)imageRefWithColor:(SKColor*)color andSize:(CGSize)size {
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
    CGContextSetFillColorWithColor(context, cgColor);
    
    // …
    
    
    // Draw a circle
    _circlePath = CGPathCreateMutable();
    
    CGPathAddArc(self.circlePath, NULL, size.width/2, size.width/2, size.width/2*0.9, 0, 2*M_PI, YES);
    CGPathCloseSubpath(self.circlePath);
    CGContextAddPath(context, self.circlePath);
    
    CGContextSetStrokeColorWithColor(context, cgColor);
    CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathStroke);

    // Get your image
    //
    imageRef = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return imageRef;
}

-(void) positionCards {
    // Remedial trig
    // x = cos(rad) * radius
    // y = sin(rad) * radius
    float radianOffset = ( 2 * M_PI ) / self.children.count;
    float radius = self.size.width/2;
    int i = 0;
    for (SKSpriteNode * aNode in self.children) {
        float angle = radianOffset * i;
        CGFloat x = cosf(angle) * radius;
        CGFloat y = sinf(angle) * radius;
        aNode.position = CGPointMake(x, y);
        i++;
    }
}


@end
