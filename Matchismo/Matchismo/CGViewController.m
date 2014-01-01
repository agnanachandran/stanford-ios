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
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberMatchControl;
// set to NO by default; which is congruent with the fact
// that 2-card-match is selected by default in the UI
@end

@implementation CGViewController

- (CardMatchingGame *)game {
    NSUInteger maxMatch = [self.numberMatchControl selectedSegmentIndex] == 0 ? 2 : 3;
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]
                                                       withMaxMatch:maxMatch];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    // Disable segmented control on (first) card button press
    [self.numberMatchControl setEnabled:NO];
    NSInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (IBAction)touchRedealButton:(UIButton *)sender
{
    [self resetGame];
}

- (IBAction)touchNumberMatchControl:(UISegmentedControl *)sender
{
    UISegmentedControl *control = sender;
    // set maximum number of cards to match
    // zeroth segment is 2-match; 1st segment is 3-match
    self.game.maxMatch = [control selectedSegmentIndex] == 0 ? 2 : 3;
}

- (void)resetGame
{
    NSUInteger maxMatch = [self.numberMatchControl selectedSegmentIndex] == 0 ? 2 : 3;
    // reset game and score property
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]
                                               withMaxMatch:maxMatch];
    [self updateUI];
    // Let user select two/three card match upon re-deal
    [self.numberMatchControl setEnabled:YES];
    
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:(card.isChosen ? @"cardfront" : @"cardback")];
}

@end
