//
//  _13_prototypeViewController.m
//  313-prototype
//
//  Created by Jonathon Rubin on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "_13_prototypeViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation _13_prototypeViewController

@synthesize cardViews, allCardViews, knownThree13CardView, mysteryThree13CardView, imagesArray, totalScoreLabel, scoreLabel, roundLabel, levelLabel, handCardFrames, knownCardFrame, mysteryCardFrame, aboveFrame, belowFrame, dataSource;

// The designated initializer. Override to perform setup that is required before the view is loaded.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    for( UIImageView * cardView in cardViews ) {
        [self.view addSubview:cardView];
    }
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    CGRect hiddenBackground = CGRectMake(self.view.bounds.origin.x, -1000, self.view.bounds.size.width, self.view.bounds.size.height);
    UIImageView * backgroundImage = [[UIImageView alloc] initWithFrame:hiddenBackground];
    backgroundImage.image = [UIImage imageNamed:@"green-leather.png"];
    backgroundImage.tag = 105;
    [self.view addSubview:backgroundImage];

    int w = 50;
    int h = 75;

    allCardViews = [NSMutableArray new];
    cardViews = [NSMutableArray new];
    handCardFrames = [NSMutableArray new];
    imagesArray = [NSMutableArray new];
    belowFrame = CGRectMake(600, 1000, w, h);
    knownCardFrame = CGRectMake(193, 365, w, h);
    mysteryCardFrame = CGRectMake(250, 365, w, h);
    
//    knownThree13CardView.frame = belowFrame;
//    mysteryThree13CardView.frame = belowFrame;

    int frameOffset = 13;
    int pad = 7;
    
    for( int i = 0; i < 3; i++)
    {
        for( int k = 0; k < 5; k++) {
            int x = frameOffset + (w/2)*(k) + pad*(k+1);
            int y = 110 + h*(i) + pad*(i+1);
 //           NSLog(@"Placing card %d at %d,%d", i*k, x, y);
            [handCardFrames addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w, h)]];
        }
    }
    
    game = [[Three13Game alloc] init];
    [game setDelegate:self];
    [self setDataSource:game];
    
    [game addObserver:self forKeyPath:@"state" options:0 context:nil];
    [game addObserver:self forKeyPath:@"level" options:0 context:nil];
    [game addObserver:self forKeyPath:@"round" options:0 context:nil];
    [game addObserver:self forKeyPath:@"currentScore" options:0 context:nil];
    [game addObserver:self forKeyPath:@"totalScore" options:0 context:nil];
    
    aboveFrame = belowFrame;
    //aboveFrame = CGRectMake(self.view.frame.size.width/2, -100, w, h);

    // Build a view for each card, tagged by number, and place outside of frame
    for (Three13Card * card in [dataSource cardsInDeck]) {
        Three13CardView * cardView = [[Three13CardView alloc] initWithFrame:aboveFrame];
        cardView.layer.cornerRadius = 6.0;
        cardView.layer.masksToBounds = YES;
        cardView.image = card.face;
        cardView.tag = card.number;
        [allCardViews addObject:cardView];
        [self.view addSubview:cardView];
    }
    
    for (Three13Card * card in [dataSource cardsInDeck]) {
        [imagesArray addObject:card.face];
    }
    Three13Card * card = [[dataSource cardsInDeck] objectAtIndex:0];
    [imagesArray addObject:card.back];
    
    [dataSource startGame];

    scoreLabel.alpha = 0;
    totalScoreLabel.alpha = 0;
    roundLabel.alpha = 0;
    levelLabel.alpha = 0;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.shadowColor = [UIColor blackColor];
    scoreLabel.shadowOffset = CGSizeMake(1, 1);
    totalScoreLabel.textColor = [UIColor whiteColor];
    totalScoreLabel.shadowColor = [UIColor blackColor];
    totalScoreLabel.shadowOffset = CGSizeMake(1, 1);
    roundLabel.textColor = [UIColor whiteColor];
    roundLabel.shadowColor = [UIColor blackColor];
    roundLabel.shadowOffset = CGSizeMake(1, 1);
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.shadowColor = [UIColor blackColor];
    levelLabel.shadowOffset = CGSizeMake(1, 1);
    scoreLabel.text = [NSString stringWithFormat:@"Current Score: %d", game.currentScore];
    totalScoreLabel.text = [NSString stringWithFormat:@"Total Score: %d", game.totalScore];
    roundLabel.text = [NSString stringWithFormat:@"Round: %d", game.round];
    levelLabel.text = [NSString stringWithFormat:@"Level: %d", game.level];
    scoreLabel.tag = 106;
    totalScoreLabel.tag = 107;
    roundLabel.tag = 108;
    levelLabel.tag = 109;
//    NSLog(@"Game started, setting known/mystery cards to %d and %d", game.knownCard.number, game.mysteryCard.number);
    
//    knownThree13CardView = (UIImageView*)[self.view viewWithTag:game.knownCard.number];
//    knownThree13CardView.frame = belowFrame;
    [self.view viewWithTag:game.knownCard.number].frame = belowFrame;
    
//    mysteryThree13CardView = (UIImageView*)[self.view viewWithTag:game.mysteryCard.number];
//    mysteryThree13CardView.frame = belowFrame;
    [self.view viewWithTag:game.mysteryCard.number].frame = belowFrame;
    
    [self.view addSubview:scoreLabel];
    [self.view addSubview:totalScoreLabel];
    [self.view addSubview:roundLabel];
    [self.view addSubview:levelLabel];
    [self createGestureRecognizers];
    [self.view setTag:110];
    [super viewDidLoad];

}


- (void)createGestureRecognizers {
//    NSLog(@"Creating gesture recognizers");
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
}

-(void) tappedKnownCard {
//    NSLog(@"Tap is in known card!");
    [game choseKnownCard];
}

-(void) tappedUnknownCard {
//    NSLog(@"Tap is in unknown card!");
    [game choseMysteryCard];
}

-(void) tappedCard: (NSInteger)cardId {
//    NSLog(@"Tap is in object tagged %d", cardId);
    [game choseCard:cardId];
}

-(IBAction) handleTap:(UIGestureRecognizer*)sender {
    
    // Find tapped card
    NSMutableArray * tappedCards = [[NSMutableArray alloc] init];
    NSMutableArray * cardsToCheck = [game allCards];
    NSMutableArray * cardIDs = [NSMutableArray new];
    for (Three13Card * card in cardsToCheck) {
        [cardIDs addObject:@(card.number)];
    }

    for( NSNumber * cardNumber in cardIDs )
    {
        Three13CardView * view = (Three13CardView*)[self.view viewWithTag:[cardNumber intValue]];
        if ([view pointInside:[sender locationInView:view] withEvent:nil]) {
            [tappedCards addObject:view];
        }
    }
    
    int i;
    int rightTag = -1;
    int lastZorder = -1;
    for (i = 0; i < tappedCards.count; i++) {
        Three13CardView * curCard = [tappedCards objectAtIndex:i];
        int zOrder = [self.view.subviews indexOfObject:curCard];
        if (zOrder > lastZorder) {
            rightTag = curCard.tag;
            lastZorder = zOrder;
        }
    }
    
    if (game.state == 0) {
        [dataSource selectCardWith:rightTag];
    }
    else if (game.state == 1) {
        [dataSource discardCardWith:rightTag];
    }
}

- (void) respondToStartOfGameWithCompletionHandler:(void (^)())completionHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Animate in the backdrop
        UIImageView * backView = (UIImageView*)[self.view viewWithTag:105];
        [UIView transitionWithView:nil duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            backView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
        } completion:^(BOOL finished) {
            completionHandler();
        } ];
    });
}

- (void) respondToEndOfLevelWithDictionary:(NSMutableDictionary*)dict andCompletionHandler:(void (^)())completionHandler {

    __block NSMutableArray * handArray = [dict objectForKey:@"hand"];
    __block NSMutableArray * deckArray = [dict objectForKey:@"deck"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayMessage:[NSString stringWithFormat:@"Scored %d", game.currentScore]];
        
        [UIView animateWithDuration:0.5 animations:^{
            for (int i = 0; i < [handArray count]; i++) {
                NSInteger tag = [[handArray objectAtIndex:i] intValue];
                Three13CardView * view = (Three13CardView*)[self.view viewWithTag:tag];
                view.frame = aboveFrame;
            }
            for (NSNumber * tag in deckArray) {
                NSInteger tagInt = [tag intValue];
                Three13CardView * cardView = (Three13CardView*)[self.view viewWithTag:tagInt];
                cardView.frame = aboveFrame;
            }
        }
        completion:^(BOOL finished) {
            //Start level
            for (int i = 0; i < [handArray count]; i++) {
                NSInteger tag = [[handArray objectAtIndex:i] intValue];
                Three13CardView * view = (Three13CardView*)[self.view viewWithTag:tag];
                view.image = [imagesArray lastObject]; //back image
            }
            completionHandler();
        }];
 
    });
}

-(void) displayMessage:(NSString*)text {
    CGRect messageFrame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.height/3, self.view.frame.size.width/3);
    UILabel * messageView = [[UILabel alloc] initWithFrame:messageFrame];
    messageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    messageView.backgroundColor = [UIColor blackColor];
    messageView.alpha = 0.0;
    messageView.layer.cornerRadius = 6;
    messageView.layer.masksToBounds = YES;
    messageView.text = text;
    messageView.textAlignment = UITextAlignmentCenter;
    messageView.adjustsFontSizeToFitWidth = YES;
    messageView.textColor = [UIColor whiteColor];
    
    [self.view addSubview:messageView];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         messageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              messageView.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                              [messageView removeFromSuperview];
                                          }
                          ];
                     }
     ];
}

-(void) respondToStartOfLevelWithDictionary:(NSMutableDictionary *)dict {
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSMutableDictionary * aDict = dict;
    dispatch_async(queue, ^{
        [self levelStarts:aDict];
    });
}

-(void) levelStarts:(NSMutableDictionary *)dict {
//    NSLog(@"Game notified view controller of start level!");
    
    [self displayMessage:[NSString stringWithFormat:@"Level %d", game.level]];

    NSMutableArray * handArray = [dict objectForKey:@"hand"];
    NSMutableArray * deckArray = [dict objectForKey:@"deck"];
    
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < [handArray count]; i++) {
            NSInteger tag = [[handArray objectAtIndex:i] intValue];
            CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
            Three13CardView * view = (Three13CardView*)[self.view viewWithTag:tag];
            [self.view bringSubviewToFront:view];
            view.image = [imagesArray lastObject]; //back image
            view.frame = frame;
//            [self moveCardWithTag:view.tag toLocation:frame];
        }
        for (NSNumber * tag in deckArray) {
            NSInteger tagInt = [tag intValue];
            Three13CardView * cardView = (Three13CardView*)[self.view viewWithTag:tagInt];
            cardView.frame = aboveFrame;
        }        
    }
    completion:^(BOOL finished) {
        //Start round
        for( NSNumber * tag in handArray) {
            [self flipViewFor:tag];
        }        
        [self roundStarts:dict];
    }];     
}

-(void) respondToStartOfRoundWithDictionary:(NSMutableDictionary *)dict {
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSMutableDictionary * aDict = dict;
    dispatch_async(queue, ^{
        [self roundStarts:aDict];
    });
}

-(void) roundStarts:(NSMutableDictionary *)dict {
//    NSLog(@"Game notified view controller of start round!");
//    mysteryThree13CardView = (UIImageView*)[self.view viewWithTag:game.mysteryCard.number];
//    knownThree13CardView = (UIImageView*)[self.view viewWithTag:game.knownCard.number];
    NSInteger knownID = [ [dict objectForKey:@"known"] intValue];
    NSInteger mysteryID = [ [dict objectForKey:@"mystery"] intValue];
    [ (Three13CardView*)[self.view viewWithTag:mysteryID] setImage:[imagesArray lastObject]];
    [ (Three13CardView*)[self.view viewWithTag:knownID] setImage:[imagesArray lastObject]];
    if (game.round == game.level ) {
        [self displayMessage:[NSString stringWithFormat:@"Last Round!"]];
    }
    [UIView transitionWithView:nil duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.view viewWithTag:knownID].userInteractionEnabled = NO;
        [self.view viewWithTag:mysteryID].userInteractionEnabled = NO;
        [self.view viewWithTag:knownID].frame = knownCardFrame;
        [self.view viewWithTag:mysteryID].frame = mysteryCardFrame;
    } completion:^(BOOL finished) {
        [self flipViewFor:[dict objectForKey:@"known"]];
        //Reveal score labels
        [UIView transitionWithView:nil duration:0.5 options:0 animations:^{
            scoreLabel.alpha = 1.0;
            totalScoreLabel.alpha = 1.0;
            roundLabel.alpha = 1.0;
            levelLabel.alpha = 1.0;
        } completion: NULL //completion:^(BOOL finished) {
//            NSLog(@"Completed label fade-in");
            
            //Pulsate known/mystery
/*
            CABasicAnimation *theAnimation;
            theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            theAnimation.duration=1.0;
            theAnimation.repeatCount=HUGE_VALF;
            theAnimation.autoreverses=YES;
            theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
            theAnimation.toValue=[NSNumber numberWithFloat:0.5];
            theAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
            [mysteryThree13CardView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
            [knownThree13CardView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
            
        }
*/
         ];
    }];
}

- (void) respondToKnownCardChosenWithDictionary:(NSMutableDictionary*)dict {
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSMutableDictionary * aDict = dict;
    dispatch_async(queue, ^{
        [self knownChosen:aDict];
    });
}

-(void) knownChosen:(NSMutableDictionary *)dict {
//    NSLog(@"Game notified view controller of known chosen!");

/*    
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
*/
    NSMutableArray * handArray = [dict objectForKey:@"hand"];
    NSInteger knownID = [[dict objectForKey:@"known"] intValue];
    NSInteger mysteryID = [[dict objectForKey:@"mystery"] intValue];
    CGRect frame = [[ handCardFrames objectAtIndex:handArray.count-1] CGRectValue];
    [self.view viewWithTag:mysteryID].userInteractionEnabled = YES;
    [self.view viewWithTag:knownID].userInteractionEnabled = YES;
    [self moveCardWithTag:mysteryID toLocation:belowFrame];
    [self moveCardWithTag:knownID toLocation:frame];    
}

- (void) respondToMysteryCardChosenWithDictionary:(NSMutableDictionary*)dict {
    dispatch_queue_t queue = dispatch_get_main_queue();
    __block NSMutableDictionary * aDict = dict;
    dispatch_async(queue, ^{
        [self mysteryChosen:aDict];
    });
}

-(void) mysteryChosen:(NSMutableDictionary *)dict {
//    NSLog(@"Game notified view controller of mystery chosen!");
    
/*
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
*/
    NSMutableArray * handArray = [dict objectForKey:@"hand"];
    NSInteger knownID = [[dict objectForKey:@"known"] intValue];
    NSInteger mysteryID = [[dict objectForKey:@"mystery"] intValue];

    [self.view viewWithTag:mysteryID].userInteractionEnabled = YES;
    [self.view viewWithTag:knownID].userInteractionEnabled = YES;

    CGRect frame = [ [handCardFrames objectAtIndex:handArray.count-1] CGRectValue];
    [self moveCardWithTag:knownID toLocation:belowFrame];
    
    [UIView animateWithDuration:0.5
        animations:^{
            [self.view bringSubviewToFront:[self.view viewWithTag:mysteryID]];
            [self.view viewWithTag:mysteryID].frame = frame;
        }
        completion:^(BOOL finished){
            [self flipViewFor:@(mysteryID)];
        }
    ];
}

-(void) flipViewFor:(NSNumber*)cardID {
    Three13CardView * cardView = (Three13CardView *) [self.view viewWithTag:[cardID intValue]];
    [ UIView transitionWithView:cardView duration:0.5
        options:UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
            if( cardView.image == [imagesArray lastObject] )
                [ cardView setImage: [imagesArray objectAtIndex:[cardID intValue]]];
            else {
                [cardView setImage: [imagesArray lastObject]];
            }
        }
        completion:NULL
    ];    
}        

-(void) flipViewForCard:(Three13Card*)card {
    Three13CardView * cardView = (Three13CardView *) [self.view viewWithTag:card.number];
    [ UIView transitionWithView:cardView duration:0.5
        options:UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
            if( cardView.image == card.back )
                [ cardView setImage: card.face];
            else {
                [cardView setImage:card.back];
            }
        }
        completion:NULL
     ];    
}

- (void) respondToCardBeingDiscardedWithDictionary:(NSMutableDictionary*)dict andCompletionHandler:(void (^)())completionHandler {
    __block NSMutableArray * handArray = [dict objectForKey:@"hand"];
    NSLog(@"Hand is %@", handArray);
    __block NSInteger discardTag = [[dict objectForKey:@"discard"] intValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5
                         animations:^{
                             Three13CardView * cardView = (Three13CardView*)[self.view viewWithTag:discardTag];
                             cardView.frame = belowFrame;
                             for (int i = 0; i < handArray.count; i++) {
                                 NSInteger cardID = [ [handArray objectAtIndex:i] intValue];
                                 CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
                                 Three13CardView * view = (Three13CardView*)[self.view viewWithTag:cardID];
                                 [self moveCardWithTag:view.tag toLocation:frame];
                             }
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 completionHandler();
                             }
                         }
         ];     

    });
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"] && [object isEqual:game] ) {
        switch (game.state) {
            case -1:
                break;
            case 0:
//                NSLog(@"Game started");
                break;
            case 1:
                break;
            default:
                break;
        }
    }

    if ([keyPath isEqualToString:@"level"] && [object isEqual:game] ) {
//        NSLog(@"On level %d", game.level);
        levelLabel.text = [NSString stringWithFormat:@"Level: %d", game.level];
    }

    if ([keyPath isEqualToString:@"round"] && [object isEqual:game] ) {
//        NSLog(@"On round %d", game.round);
        roundLabel.text = [NSString stringWithFormat:@"Round: %d", game.round];
    }

    if ([keyPath isEqualToString:@"currentScore"] && [object isEqual:game] ) {
//        NSLog(@"Current score %d", game.currentScore);
        scoreLabel.text = [NSString stringWithFormat:@"Current Score: %d", game.currentScore];
    }

    if ([keyPath isEqualToString:@"totalScore"] && [object isEqual:game] ) {
//        NSLog(@"Total score %d", game.totalScore);
        totalScoreLabel.text = [NSString stringWithFormat:@"Total Score: %d", game.totalScore];
    }
}

- (void) moveCardWithTag:(NSInteger)tag toLocation:(CGRect)frame {
    Three13CardView * cardView = (Three13CardView*)[self.view viewWithTag:tag];
    [self.view bringSubviewToFront:cardView];
    [UIView animateWithDuration:0.5 animations:^{
        cardView.frame = frame;
    }];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.scoreLabel = nil;
}



@end
