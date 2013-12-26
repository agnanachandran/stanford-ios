//
//  PlayingCard.h
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/24/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;

@end
