//
//  Three13CardView.m
//  313-prototype
//
//  Created by Jonathon Rubin on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Three13CardView.h"


@implementation Three13CardView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    CGRect __block frame = self.frame;
    normalFrame = frame;
    frame.size.width = frame.size.width * 1.5;
    frame.size.height = frame.size.height * 1.5;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.frame = frame;
                         self.alpha = 0.6;    
                     }
    ];

    [[self superview] bringSubviewToFront:self];
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect __block frame = self.frame;
    frame.size.width = normalFrame.size.width;
    frame.size.height = normalFrame.size.height;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.frame = frame;
                         self.alpha = 1.0;    
                     }
    ];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    CGRect __block frame = self.frame;
    frame.size.width = normalFrame.size.width;
    frame.size.height = normalFrame.size.height;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.frame = frame;
                         self.alpha = 1.0;    
                     }
    ];
}

@end
