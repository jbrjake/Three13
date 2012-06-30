//
//  _13_prototypeViewController.h
//  313-prototype
//
//  Created by Jonathon Rubin on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three13Game.h"
#import "Three13CardView.h"
@interface _13_prototypeViewController : UIViewController {

    Three13Game * game;
    NSMutableArray * cardViews;
    NSMutableArray * allCardViews;
    Three13CardView * knownThree13CardView;
    Three13CardView * mysteryThree13CardView;
    NSMutableArray * imagesArray;
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

@property(nonatomic, strong) NSMutableArray * cardViews;
@property(nonatomic, strong) NSMutableArray * allCardViews;
@property(nonatomic, strong) Three13CardView * knownThree13CardView;
@property(nonatomic, strong) Three13CardView * mysteryThree13CardView;
@property(nonatomic, strong) NSMutableArray * imagesArray;
@property(nonatomic, strong) IBOutlet UILabel * totalScoreLabel;
@property(nonatomic, strong) IBOutlet UILabel * scoreLabel;
@property(nonatomic, strong) IBOutlet UILabel * roundLabel;
@property(nonatomic, strong) IBOutlet UILabel * levelLabel;
@property(nonatomic, strong) NSMutableArray * handCardFrames;
@property(nonatomic) CGRect knownCardFrame;
@property(nonatomic) CGRect mysteryCardFrame;
@property(nonatomic) CGRect aboveFrame;
@property(nonatomic) CGRect belowFrame;

-(IBAction) handleTap:(UIGestureRecognizer*)sender;
-(void) createGestureRecognizers;
-(void) gameStarts:(NSNotification *)note;
-(void) levelEnds:(NSNotification *)note;
-(void) levelStarts:(NSNotification *)note;
-(void) roundStarts:(NSNotification *)note;
-(void) knownChosen:(NSNotification *)note;
-(void) mysteryChosen:(NSNotification *)note;
-(void) cardDiscarded:(NSNotification *)note;

-(void) moveCardWithTag:(NSInteger)tag toLocation:(CGRect)frame;
-(void) flipViewFor:(NSNumber*)cardID;
-(void) flipViewForCard:(Three13Card *)card;

-(void) displayMessage:(NSString*)text;

@end

