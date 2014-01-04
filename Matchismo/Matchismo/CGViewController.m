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
// array of CardMatchingGame and array of infoLabel strings
@property (strong, nonatomic) NSMutableArray *history; // of infoLabel NSStrings
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberMatchControl;
@end

@implementation CGViewController

- (void)viewDidLoad
{
    [self resetGame];
}

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
    
    // cards that have are chosen and not matched; used for infoLabel's text
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        if (card.isChosen && !card.isMatched) {
            [chosenCards addObject:card];
        }
    }
    
    // Disable segmented control on (first) card button press
    [self.numberMatchControl setEnabled:NO];
    NSInteger cardIndex = [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
    Card *card = [self.game cardAtIndex:cardIndex]; // card the user just chose
    
    // remove card if already in chosenCards (i.e., it has just been unselected
    // otherwise add it since it was just chosen by the user
    if ([chosenCards containsObject:card]) {
        [chosenCards removeObject:card];
    } else {
        [chosenCards addObject:card];
    }
    [self updateInfoLabelWithCards:chosenCards];
    [self updateHistory];
}

- (NSMutableArray *)history
{
    if (!_history) _history = [self restartHistory];
    return _history;
}

- (NSMutableArray *)restartHistory
{
    self.historySlider.value = 0;
    self.historySlider.maximumValue = 0;
    NSMutableArray *history = [[NSMutableArray alloc] init];
    [history addObject:self.infoLabel.text];
    return history;
}

- (void)updateHistory
{
    [self.history addObject:self.infoLabel.text];
    [self.historySlider setMaximumValue:self.historySlider.maximumValue + 1]; // increment maximum possible value of slider
    [self.historySlider setValue:self.historySlider.maximumValue]; // set to maximum value
    self.infoLabel.alpha = 1;
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    [self revertHistory];
    [self updateUI];
}

- (void)revertHistory
{
    NSInteger sliderValue = (int)roundf([self.historySlider value]);
    self.infoLabel.text = self.history[sliderValue];
    if (sliderValue != self.historySlider.maximumValue) {
        self.infoLabel.alpha = 0.3;
    } else {
        self.infoLabel.alpha = 1;
    }
}

- (IBAction)touchRedealButton:(UIButton *)sender
{
    [self resetGame];
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
    self.infoLabel.text = @"";
    self.history = [self restartHistory];
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
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateInfoLabelWithCards:(NSMutableArray *)chosenCards
{
    // whether or not the cards array contained a match
    BOOL didMatch = self.game.justMatched;
    
    if ([chosenCards count] == 0) {
        self.infoLabel.text = @"";
    } else if ([chosenCards count] == 1) {
        Card *card = [chosenCards firstObject];
        if (card.isChosen) {
            self.infoLabel.text = card.contents;
        } else {
            self.infoLabel.text = @"";
        }
    } else if ([chosenCards count] == 2) {
        Card *firstCard = chosenCards[0];
        Card *secondCard = chosenCards[1];
        if (self.game.maxMatch == 2) {
            if (didMatch) {
                self.infoLabel.text = [NSString stringWithFormat:@"Matched %@ and %@ for %ld points.", firstCard.contents, secondCard.contents, (long)self.game.lastScore];
            } else {
                self.infoLabel.text = [NSString stringWithFormat:@"%@ and %@ don't match! Penalty of %ld points.", firstCard.contents, secondCard.contents, (long)self.game.lastScore];
            }
        } else if (self.game.maxMatch == 3) {
            // User just chose another card in 3-match mode
            self.infoLabel.text = secondCard.contents;
        }
    } else if ([chosenCards count] == 3 && self.game.maxMatch == 3) {
        Card *firstCard = chosenCards[0];
        Card *secondCard = chosenCards[1];
        Card *thirdCard = chosenCards[2];
        if (didMatch) {
            self.infoLabel.text = [NSString stringWithFormat:@"Matched %@, %@, and %@ for %ld points.", firstCard.contents, secondCard.contents, thirdCard.contents, self.game.lastScore];
        } else {
            self.infoLabel.text = [NSString stringWithFormat:@"%@, %@, and %@ don't match! Penalty of %ld points.", firstCard.contents, secondCard.contents, thirdCard.contents, self.game.lastScore];
        }
    }
}

- (IBAction)touchNumberMatchControl:(UISegmentedControl *)sender
{
    UISegmentedControl *control = sender;
    // set maximum number of cards to match
    // zeroth segment is 2-match; 1st segment is 3-match
    self.game.maxMatch = [control selectedSegmentIndex] == 0 ? 2 : 3;
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
