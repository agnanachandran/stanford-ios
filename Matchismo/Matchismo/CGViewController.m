//
//  CGViewController.m
//  Matchismo
//
//  Created by Anojh Gnanachandran on 12/22/2013.
//  Copyright (c) 2013 Anojh Gnanachandran. All rights reserved.
//

#import "CGViewController.h"
#import "PlayingCardDeck.h"

@interface CGViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) int flipCount;
@end

@implementation CGViewController

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    
    return _deck;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flip count: %d", flipCount);
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
        self.flipCount++;
    }
}

@end
