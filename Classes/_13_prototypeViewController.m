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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        game = [[Three13Game alloc] init];
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    for( UIImageView * cardView in cardViews ) {
        [self.view addSubview:cardView];
    }
}
*/

- (void) updateDisplay {
    
    NSLog(@"Updating display");
    for (UIImageView * cardView in allCardViews) {
        cardView.frame = aboveFrame;
    }
    
//    for( UIImageView * cardView in cardViews ) {
//        [UIView animateWithDuration:1.0 animations:^{
//            cardView.alpha = 0.0;
//        }];
//        cardView.image = nil;
//        cardView.tag = 0;
//    }
//    NSLog(@"Nilled hand card views");
    
    for (int i = 0; i < [game.hand.cards count]; i++) {
        Three13Card * drawnCard = [game.hand showCardAt:i];
        CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
        UIImageView * view = (UIImageView*)[self.view viewWithTag:drawnCard.number];
        view.frame = frame;
    }
    
//    for( int i = 0; i < [game.hand.cards count]; i++) {
//        Three13Card * drawnThree13Card = [game.hand showCardAt:i];
//        [ [cardViews objectAtIndex:i ] setImage: drawnThree13Card.face];
//        [ [cardViews objectAtIndex:i ] setTag: drawnThree13Card.number];
//        UIImageView * cardView = [cardViews objectAtIndex:i];
//        [UIView animateWithDuration:1.0 animations:^{
//            cardView.alpha = 1.0;
//        }];
//    }
//    NSLog(@"Set hand card views to hand");
    
//    NSLog(@"Game state is: %d", game.state);
    if (game.knownCard && game.state == 0) {
        knownThree13CardView = (UIImageView*)[self.view viewWithTag:game.knownCard.number];
        knownThree13CardView.frame = knownCardFrame;
        
//        NSLog(@"Setting known card face");
//        NSLog(@"Setting known card number");
//        [UIView animateWithDuration:1.0 animations:^{
//            knownThree13CardView.alpha = 1.0;
//        }];
        
    }
    else {
        knownThree13CardView = nil;
//        [UIView animateWithDuration:0.2 animations:^{
//            knownThree13CardView.alpha = 0.0;
//        }];        
//        [knownThree13CardView setImage:nil];
//        [knownThree13CardView setTag:nil];
    }
//    NSLog(@"Set known card");
    if (game.mysteryCard && game.state == 0) {
        mysteryThree13CardView = (UIImageView*)[self.view viewWithTag:game.mysteryCard.number];
        mysteryThree13CardView.frame = mysteryCardFrame;
        mysteryThree13CardView.image = game.mysteryCard.back;
//        [UIView animateWithDuration:1.0 animations:^{
//            mysteryThree13CardView.alpha = 1.0;
//        }];
        
    }
    else {
        mysteryThree13CardView = nil;
//        [UIView animateWithDuration:0.2 animations:^{
//            mysteryThree13CardView.alpha = 0.0;
//        }];        
//        [mysteryThree13CardView setTag:nil];
//        [mysteryThree13CardView setImage:nil];    
    }
//    NSLog(@"Set unknown card");
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarts) name:@"Start Game" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelStarts) name:@"Start Level" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roundStarts) name:@"Start Round" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(knownChosen) name:@"Choose Known" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mysteryChosen) name:@"Choose Mystery" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardDiscarded) name:@"Discard Card" object:nil];

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
//            UIImageView * cardView = [ [UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, -100, w, h)];
//            cardView.layer.cornerRadius = 6.0;
//            cardView.layer.masksToBounds = YES;
//            [cardViews addObject:cardView];
//            [cardView release];
        }
    }
    
//    for( UIImageView * cardView in cardViews ) {
//        [self.view addSubview:cardView];
//    }    
    game = [[Three13Game alloc] init];
    [game addObserver:self forKeyPath:@"state" options:0 context:nil];
    [game addObserver:self forKeyPath:@"level" options:0 context:nil];
    [game addObserver:self forKeyPath:@"round" options:0 context:nil];
    [game addObserver:self forKeyPath:@"currentScore" options:0 context:nil];
    [game addObserver:self forKeyPath:@"totalScore" options:0 context:nil];
    
    aboveFrame = CGRectMake(self.view.frame.size.width/2, -100, w, h);
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
//    for( int i = 0; i < [game.hand.cards count]; i++) {
//        Three13Card * drawnThree13Card = [game.hand showCardAt:i];
//        [ [cardViews objectAtIndex:i ] setImage: drawnThree13Card.face];
//        [ [cardViews objectAtIndex:i ] setTag: drawnThree13Card.number];
//    }
    
    
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
    knownThree13CardView.layer.cornerRadius = 6.0;
    knownThree13CardView.layer.masksToBounds = YES;
    knownThree13CardView.frame = belowFrame;
    
    mysteryThree13CardView = [self.view viewWithTag:game.mysteryCard.number];
    mysteryThree13CardView.layer.cornerRadius = 6.0;
    mysteryThree13CardView.layer.masksToBounds = YES;
    [mysteryThree13CardView setTag:game.mysteryCard.number];
    [mysteryThree13CardView setImage:game.mysteryCard.back];
    mysteryThree13CardView.frame = belowFrame;
//    mysteryThree13CardView.animationImages = imagesArray;
//    mysteryThree13CardView.startAnimating;
//    [self.view addSubview:knownThree13CardView];
//    [self.view addSubview:mysteryThree13CardView];
    [self.view addSubview:scoreLabel];
    [self.view addSubview:totalScoreLabel];
    [self.view addSubview:roundLabel];
    [self.view addSubview:levelLabel];
    [self createGestureRecognizers];
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
    NSLog(@"Tap is in known card!");
    if (knownThree13CardView.image != nil) {
        [game choseKnownCard];
        [self updateDisplay];
        scoreLabel.text = @"";
    }
}

-(void) tappedUnknownCard {
    NSLog(@"Tap is in unknown card!");
    if (mysteryThree13CardView.image != nil) {
        [game choseMysteryCard];
        [self updateDisplay];
        scoreLabel.text = @"";
    }
}

-(void) tappedCard: (NSInteger)cardId {
    NSLog(@"Tap is in object tagged %d", cardId);
    [game choseCard:cardId];
    [self updateDisplay];
}

-(IBAction) handleTap:(UIGestureRecognizer*)sender {
    
    if ([knownThree13CardView pointInside:[sender locationInView:knownThree13CardView] withEvent:nil]) {
        [self tappedKnownCard];
        return;
    }
    else {
        if ([mysteryThree13CardView pointInside:[sender locationInView:mysteryThree13CardView   ] withEvent:nil]) {
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
    NSLog(@"Game notified view controller of start!");
    
    //Animate in the backdrop    
    UIImageView * backView = [self.view viewWithTag:105];
    [UIView transitionWithView:nil duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
		backView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
	} completion:^(BOOL finished) {
        [self levelStarts];
    } ];
    
}

-(void) levelStarts {
    NSLog(@"Game notified view controller of start level!");
    //Animate in the cards for the hand
    [UIView transitionWithView:nil duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        for (int i = 0; i < [game.hand.cards count]; i++) {
            Three13Card * drawnCard = [game.hand showCardAt:i];
            CGRect frame = [[handCardFrames objectAtIndex:i] CGRectValue];
            UIImageView * view = [self.view viewWithTag:drawnCard.number];
            view.frame = frame;
        }
    } completion:^(BOOL finished) {
            
            //Start round
            [self roundStarts];
            //Reveal score labels
/*            CABasicAnimation *labelAnimation =
            [CABasicAnimation animationWithKeyPath:@"opacity"];
            [labelAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
            [labelAnimation setToValue:[NSNumber numberWithFloat:1.0]];
            [labelAnimation setDuration:1.0];
            
            scoreLabel.alpha = 1.0;
            totalScoreLabel.alpha = 1.0;
            roundLabel.alpha = 1.0;
            levelLabel.alpha = 1.0;
            [scoreLabel.layer addAnimation:labelAnimation forKey:nil];
            [totalScoreLabel.layer addAnimation:labelAnimation forKey:nil];
            [roundLabel.layer addAnimation:labelAnimation forKey:nil];
            [levelLabel.layer addAnimation:labelAnimation forKey:nil];            
 */
        }];

/*        
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint startPoint = CGPointMake(view.frame.origin.x + (view.frame.size.width/2), view.frame.origin.y + (view.frame.size.height/2));
        CGPoint endPoint = CGPointMake(rect.origin.x + (rect.size.width/2), rect.origin.y + (rect.size.height/2));
        [animation setFromValue:[NSValue valueWithPoint:startPoint]];
        [animation setToValue:[NSValue valueWithPoint:endPoint]];
        [animation setDuration:1.0];
        
        [view.layer setPosition:endPoint];
        
        [view.layer addAnimation:animation forKey:nil];
*/
}

-(void) roundStarts {
    NSLog(@"Game notified view controller of start round!");
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
            NSLog(@"Completed label fade-in");
            
            //Pulsate known/mystery
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
            
        } ];

/*
        CABasicAnimation *labelAnimation =
        [CABasicAnimation animationWithKeyPath:@"opacity"];
        [labelAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [labelAnimation setToValue:[NSNumber numberWithFloat:1.0]];
        [labelAnimation setDuration:1.0];
        
        scoreLabel.alpha = 1.0;
        totalScoreLabel.alpha = 1.0;
        roundLabel.alpha = 1.0;
        levelLabel.alpha = 1.0;
        [scoreLabel.layer addAnimation:labelAnimation forKey:nil];
        [totalScoreLabel.layer addAnimation:labelAnimation forKey:nil];
        [roundLabel.layer addAnimation:labelAnimation forKey:nil];
        [levelLabel.layer addAnimation:labelAnimation forKey:nil];
*/
    }];
    
}

-(void) knownChosen {
    NSLog(@"Game notified view controller of known chosen!");
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
}

-(void) mysteryChosen {
    NSLog(@"Game notified view controller of mystery chosen!");
    [mysteryThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    [knownThree13CardView.layer removeAnimationForKey:@"animateOpacity"];
    mysteryThree13CardView.image = game.mysteryCard.face;
}

-(void) cardDiscarded {
    NSLog(@"Game notified view controller of discarded card!");
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"] && [object isEqual:game] ) {
        switch (game.state) {
            case -1:
                break;
            case 0:
                NSLog(@"Game started");
                break;
            case 1:
                break;
            default:
                break;
        }
    }

    if ([keyPath isEqualToString:@"level"] && [object isEqual:game] ) {
        NSLog(@"On level %d", game.level);
        levelLabel.text = [NSString stringWithFormat:@"Level: %d", game.level];
    }

    if ([keyPath isEqualToString:@"round"] && [object isEqual:game] ) {
        NSLog(@"On round %d", game.round);
        roundLabel.text = [NSString stringWithFormat:@"Round: %d", game.round];
    }

    if ([keyPath isEqualToString:@"currentScore"] && [object isEqual:game] ) {
        NSLog(@"Current score %d", game.currentScore);
        scoreLabel.text = [NSString stringWithFormat:@"Current Score: %d", game.currentScore];
    }

    if ([keyPath isEqualToString:@"totalScore"] && [object isEqual:game] ) {
        NSLog(@"Total score %d", game.totalScore);
        totalScoreLabel.text = [NSString stringWithFormat:@"Total Score: %d", game.totalScore];
    }
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
    NSLog(@"Releasing game model.");
    [game release];
    [super dealloc];
}

@end
