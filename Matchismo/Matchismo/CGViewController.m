//
//  CGViewController.m
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/22/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "CGViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CGViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CGViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame  alloc] initWithCardCount:[self.cardButtons count]
                                                           usingDeck:self.deck];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([self.deck count]) {
        if ([sender.currentTitle length]) {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                              forState:UIControlStateNormal];
            [sender setTitle:@"" forState:UIControlStateNormal];
        } else {
            Card *topCard = [self.deck drawRandomCard];
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                              forState:UIControlStateNormal];
            [sender setTitle:[topCard contents] forState:UIControlStateNormal];
        }
    }
}

@end
