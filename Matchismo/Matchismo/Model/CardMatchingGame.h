//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/29/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

@end
