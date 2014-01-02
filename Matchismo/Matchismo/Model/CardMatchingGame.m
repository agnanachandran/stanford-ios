//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/29/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, readwrite) BOOL justMatched;
// though readwrite is the default, we say readwrite
// to override the readonly in the public API

@property (strong,nonatomic) NSMutableArray *cards; // of Card

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                     withMaxMatch:(NSUInteger)maxMatch
{
    if (count < 2) {
        self = nil;
        return self;
    }
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.maxMatch = maxMatch;
    return self;
}

static const int MISMATCHED_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        // Choosing a card that has already been chosen flips the card back over
        // That's dealt with in the controller though
        if (card.isChosen) {
            card.chosen = NO;
        }
        // match against another card
        // Look in self.cards for the possible match
        else {
            // array of all the cards to match (other than the card that was touched)
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [otherCards addObject:otherCard];
                }
                // stop searching; we've found all possible matches
                if ([otherCards count] == self.maxMatch - 1) break;
            }
            if ([otherCards count] == self.maxMatch - 1) {
                int matchScore = [card match:otherCards];
                if (matchScore) {
                    self.justMatched = YES;
                    self.lastScore = matchScore * MATCH_BONUS;
                    self.score += self.lastScore;
                    card.matched = YES;
                    for (Card *matchCard in otherCards) {
                        matchCard.matched = YES;
                    }
                } else {
                    self.justMatched = NO;
                    self.lastScore = MISMATCHED_PENALTY;
                    self.score -= self.lastScore;
                    for (Card *matchCard in otherCards) {
                        matchCard.chosen = NO;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (instancetype)init {
    return nil;
}

@end
