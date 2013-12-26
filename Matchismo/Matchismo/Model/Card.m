//
//  Card.m
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/24/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
