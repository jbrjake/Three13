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
#warning Temporarily including the Player class in the VC for testing
#import "Three13Player.h"

@interface _13_prototypeViewController : UIViewController <Three13GameDelegate> {

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
    
    NSObject <Three13ViewDataSource> * dataSource;
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
@property (nonatomic, strong) NSObject <Three13ViewDataSource> * dataSource;

-(IBAction) handleTap:(UIGestureRecognizer*)sender;
-(void) createGestureRecognizers;
-(void) levelStarts:(NSMutableDictionary *)dict;
-(void) roundStarts:(NSMutableDictionary *)dict;
-(void) knownChosen:(NSMutableDictionary *)dict;
-(void) mysteryChosen:(NSMutableDictionary *)dict;

-(void) moveCardWithTag:(NSInteger)tag toLocation:(CGRect)frame;
-(void) flipViewFor:(NSNumber*)cardID;
-(void) flipViewForCard:(Three13Card *)card;

-(void) displayMessage:(NSString*)text;

@end

