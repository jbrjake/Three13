//
//  _13_prototypeAppDelegate.h
//  313-prototype
//
//  Created by Jonathon Rubin on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _13_prototypeViewController;

@interface _13_prototypeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    _13_prototypeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet _13_prototypeViewController *viewController;

@end

