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

@synthesize cardViews, allCardViews, knownThree13CardView, mysteryThree13CardView, totalScoreLabel, scoreLabel, roundLabel, levelLabel, handCardFrames, knownCardFrame, mysteryCardFrame, aboveFrame, belowFrame;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarts) name:@"Start Game" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelStarts) name:@"Start Level" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roundStarts) name:@"Start Round" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knownChosen) name:@"Choose Known" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mysteryChosen) name:@"Choose Mystery" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDiscarded:) name:@"Discard Card" object:nil];

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
    belowFrame = CGRectMake(600, 1000, w, h);
    knownCardFrame = CGRectMake(193, 365, w, h);
    mysteryCardFrame = CGRectMake(250, 365, w, h);
    
    knownThree13CardView.frame = belowFrame;
    mysteryThree13CardView.frame = belowFrame;

    int frameOffset = 13;
    int pad = 7;
    
    for( int i = 0; i < 3; i++)
    {
        for( int k = 0; k < 5; k++) {
            int x = frameOffset + w*(k) + pad*(k+1);
            int y = 110 + h*(i) + pad*(i+1);
 //           NSLog(@"Placing card %d at %d,%d", i*k, x, y);
            [handCardFrames addObject:[NSValue valueWithCGRect:CGRectMake(x, y, w, h)]];
        }
    }
    
    game = [[Three13Game alloc] init];
    [game addObserver:self forKeyPath:@"state" options:0 context:nil];
    [game addObserver:self forKeyPath:@"level" options:0 context:nil];
    [game addObserver:self forKeyPath:@"round" options:0 context:nil];
    [game addObserver:self forKeyPath:@"currentScore" options:0 context:nil];
    [game addObserver:self forKeyPath:@"totalScore" options:0 context:nil];
    
    aboveFrame = belowFrame;
    //aboveFrame = CGRectMake(self.view.frame.size.width/2, -100, w, h);

    // Build a view for each card, tagged by number, and place outside of frame
    for (Three13Card * card in game.deck.cards) {
        UIImageView * cardView = [[UIImageView alloc] initWithFrame:aboveFrame];
        cardView.layer.cornerRadius = 6.0;
        cardView.layer.masksToBounds = YES;
        cardView.image = card.face;
        cardView.tag = card.number;
        [allCardViews addObject:cardView];
        [self.view addSubview:cardView];
        [cardView release];
    }
    
    NSMutableArray * imagesArray = [NSMutableArray new];
    for (Three13Card * card in game.deck.cards) {
        [imagesArray addObject:card.face];
    }
    
    [game startGame];

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
//    NSLog(@"Game started, setting known/mystery cards to %d and %d", game.knownCard.number, game.mysteryCard.number);
    
    knownThree13CardView = [self.view viewWithTag:game.knownCard.number];
    knownThree13CardView.frame = belowFrame;
    
    mysteryThree13CardView = [self.view viewWithTag:game.mysteryCard.number];
    mysteryThree13CardView.frame = belowFrame;

    [self.view addSubview:scoreLabel];
    [self.view addSubview:totalScoreLabel];
    [self.view addSubview:roundLabel];
    [self.view addSubview:levelLabel];
    [self createGestureRecognizers];
    [self.view setTag:106];
    [super viewDidLoad];

}


- (void)createGestureRecognizers {
//    NSLog(@"Creating gesture recognizers");
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    [singleTap release];
    
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
    
    if ([knownThree13CardView pointInside:[sender locationInView:knownThree13CardView] withEvent:nil] && game.state == 0) {
        [self tappedKnownCard];
        return;
    }
    else {
        if ([mysteryThree13CardView pointInside:[sender locationInView:mysteryThree13CardView   ] withEvent:nil] && game.state == 0) {
            [self tappedUnknownCard];
            return;
        }
    }

    for( UIView * view in self.view.subviews )
    {
        if ([view pointInside:[sender locationInView:view] withEvent:nil] && view.tag < 105) {
            [self tappedCard:view.tag];
        }
    }
    
}

-(void) gameStarts {
//    NSLog(@"Game notified view controller of start!");
    
    //Animate in the backdrop    
    UIImageView * backView = [self.view viewWithTag:105];
    [UIView transitionWithView:nil duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
		backView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
	} completion:^(BOOL finished) {
        [self levelStarts];
    } ];
    
}

-(void) levelStarts {
//    NSLog(@"Game notified view controller of start level!");
    //Animate in the cards for the hand
    [UIView transitionWithView:nil duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        for (int i = 0; i < [game.hand.cards count]; i++) {
            Three13Card * drawnCard = [game.hand showCardAt:i];
            CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
            UIImageView * view = (UIImageView*)[self.view viewWithTag:drawnCard.number];
            [self moveCardWithTag:view.tag toLocation:frame];
        }
        for (Three13Card * card in game.deck.cards) {
            UIImageView * cardView = (UIImageView*)[self.view viewWithTag:card.number];
             cardView.frame = aboveFrame;
        }
    } completion:^(BOOL finished) {
        //Start round
        [self roundStarts];
    }];
}

-(void) roundStarts {
//    NSLog(@"Game notified view controller of start round!");
    mysteryThree13CardView = (UIImageView*)[self.view viewWithTag:game.mysteryCard.number];
    knownThree13CardView = (UIImageView*)[self.view viewWithTag:game.knownCard.number];
    mysteryThree13CardView.image = game.mysteryCard.back;
    [UIView transitionWithView:nil duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        knownThree13CardView.frame = knownCardFrame;
        mysteryThree13CardView.frame = mysteryCardFrame;
    } completion:^(BOOL finished) {
        //Reveal score labels
        [UIView transitionWithView:nil duration:1.0 options:nil animations:^{
            scoreLabel.alpha = 1.0;
            totalScoreLabel.alpha = 1.0;
            roundLabel.alpha = 1.0;
            levelLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
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
*/            
        }];
    }];
}

-(void) knownChosen {
//    NSLog(@"Game notified view controller of known chosen!");

/*    
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
*/
    CGRect frame = [[ handCardFrames objectAtIndex:game.hand.cards.count-1] CGRectValue];
    [self moveCardWithTag:mysteryThree13CardView.tag toLocation:belowFrame];
    [self moveCardWithTag:knownThree13CardView.tag toLocation:frame];    
}

-(void) mysteryChosen {
//    NSLog(@"Game notified view controller of mystery chosen!");
    
/*
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
*/
    int mysteryTag = mysteryThree13CardView.tag;
    CGRect frame = [ [handCardFrames objectAtIndex:game.hand.cards.count-1] CGRectValue];
    [self moveCardWithTag:knownThree13CardView.tag toLocation:belowFrame];

    [UIView animateWithDuration:1
        animations:^{
            mysteryThree13CardView.frame = frame;
        }
        completion:^(BOOL finished){
            UIImageView * mysteryView = (UIImageView *) [self.view viewWithTag:mysteryTag];
            [self flipViewForCard:game.mysteryCard];
        }
    ];
}

-(void) flipViewForCard:(Three13Card*)card {
    UIImageView * cardView = (UIImageView *) [self.view viewWithTag:card.number];
    [ UIView transitionWithView:cardView duration:1.0
        options:UIViewAnimationOptionTransitionFlipFromLeft
        animations:^(void) {
            [ cardView setImage: card.face];
        }
        completion:NULL
     ];    
}

-(void) cardDiscarded:(NSNotification *)note {
 //   NSLog(@"Game notified view controller of discarded card %@!", [note.userInfo objectForKey:@"discard"]);
    NSInteger discardTag = [[note.userInfo objectForKey:@"discard"] intValue];
    [self moveCardWithTag:discardTag toLocation:belowFrame];
    for (int i = 0; i < [game.hand.cards count]; i++) {
        Three13Card * drawnCard = [game.hand showCardAt:i];
        CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
        UIImageView * view = (UIImageView*)[self.view viewWithTag:drawnCard.number];
        [self moveCardWithTag:view.tag toLocation:frame];
    }    
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
    UIImageView * cardView = (UIImageView*)[self.view viewWithTag:tag];
    [UIView animateWithDuration:1 animations:^(void) {
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


- (void)dealloc {
//    NSLog(@"Releasing game model.");
    [game release];
    [super dealloc];
}

@end
