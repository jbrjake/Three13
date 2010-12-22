//
//  _13_prototypeViewController.h
//  313-prototype
//
//  Created by Jonathon Rubin on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three13Game.h"
@interface _13_prototypeViewController : UIViewController {

    Three13Game * game;
    NSMutableArray * cardViews;
    IBOutlet UIImageView * knownThree13CardView;
    IBOutlet UIImageView * mysteryThree13CardView;
    IBOutlet UILabel * totalScorLabel;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * roundLabel;
    IBOutlet UILabel * levelLabel;
    NSMutableArray * handCardFrames;
    CGRect knownCardFrame;
    CGRect mysteryCardFrame;
}

@property(nonatomic, retain) NSMutableArray * cardViews;
@property(nonatomic, retain) IBOutlet UIImageView * knownThree13CardView;
@property(nonatomic, retain) IBOutlet UIImageView * mysteryThree13CardView;
@property(nonatomic, retain) IBOutlet UILabel * totalScoreLabel;
@property(nonatomic, retain) IBOutlet UILabel * scoreLabel;
@property(nonatomic, retain) IBOutlet UILabel * roundLabel;
@property(nonatomic, retain) IBOutlet UILabel * levelLabel;
@property(nonatomic, retain) NSMutableArray * handCardFrames;
@property(nonatomic) CGRect knownCardFrame;
@property(nonatomic) CGRect mysteryCardFrame;

-(IBAction) handleTap:(UIGestureRecognizer*)sender;

@end
