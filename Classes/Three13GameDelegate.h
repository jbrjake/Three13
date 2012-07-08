//
//  Three13GameDelegate.h
//  313-prototype
//
//  Created by Jonathon Rubin on 7/6/12.
//  Copyright (c) 2012 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Three13GameDelegate <NSObject>

- (void) respondToStartOfGameWithCompletionHandler:(void (^)())completionHandler;
- (void) respondToEndOfLevelWithDictionary:(NSDictionary*)dict andCompletionHandler:(void (^)())completionHandler;
- (void) respondToCardBeingDiscardedWithDictionary:(NSDictionary*)dict andCompletionHandler:(void (^)())completionHandler;

@end
