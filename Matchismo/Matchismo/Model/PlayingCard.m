//
//  PlayingCard.m
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/24/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        } else if (self.rank == otherCard.rank) {
            score = 4;
        }
    }
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide both the setter and the getter methods

+ (NSArray *)validSuits
{
    return @[@"♥︎", @"♦︎", @"♠︎", @"♣︎"];
}

- (void)setSuit:(NSString *)suit
{
    // If suit is a valid suit, set self.suit to suit
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?"; // if suit is not initialized/is nil, return dummy value of @"?", otherwise return the suit
}

// We'll leave this one private since the public API for the rank is purely numeric
+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

 // Use self instead of class name since we want any subclasses
 // of this class to use an overridden version of rankStrings
 // (if it exists) rather than PlayingCard's rankStrings
+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    // Use PlayingCard, not 'self', since maxRank is a class method, not an instance method
    if (rank <= [PlayingCard maxRank]) { 
        _rank = rank;
    }
}

@end
