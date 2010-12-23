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
    NSMutableArray * allCardViews;
    UIImageView * knownThree13CardView;
    UIImageView * mysteryThree13CardView;
    IBOutlet UILabel * totalScorLabel;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * roundLabel;
    IBOutlet UILabel * levelLabel;
    NSMutableArray * handCardFrames;
    CGRect knownCardFrame;
    CGRect mysteryCardFrame;
    CGRect aboveFrame;
    CGRect belowFrame;
}

@property(nonatomic, retain) NSMutableArray * cardViews;
@property(nonatomic, retain) NSMutableArray * allCardViews;
@property(nonatomic, retain) UIImageView * knownThree13CardView;
@property(nonatomic, retain) UIImageView * mysteryThree13CardView;
@property(nonatomic, retain) IBOutlet UILabel * totalScoreLabel;
@property(nonatomic, retain) IBOutlet UILabel * scoreLabel;
@property(nonatomic, retain) IBOutlet UILabel * roundLabel;
@property(nonatomic, retain) IBOutlet UILabel * levelLabel;
@property(nonatomic, retain) NSMutableArray * handCardFrames;
@property(nonatomic) CGRect knownCardFrame;
@property(nonatomic) CGRect mysteryCardFrame;
@property(nonatomic) CGRect aboveFrame;
@property(nonatomic) CGRect belowFrame;

-(IBAction) handleTap:(UIGestureRecognizer*)sender;
-(void) createGestureRecognizers;
-(void) levelStarts;
-(void) roundStarts;
-(void) moveCardWithTag:(NSInteger)tag toLocation:(CGRect)frame;
-(void) flipViewForCard:(Three13Card *)card;
@end

