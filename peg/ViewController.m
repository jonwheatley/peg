//
//  ViewController.m
//  peg
//
//  Created by Jon Wheatley on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

@implementation ViewController

#define EMPTY 1
#define PEG 2
#define PEGPRESSED 3
#define JUMPTO 4

@synthesize a1;
@synthesize a2;
@synthesize a3;
@synthesize a4;
@synthesize a5;
@synthesize a6;
@synthesize a7;

@synthesize b1;
@synthesize b2;
@synthesize b3;
@synthesize b4;
@synthesize b5;
@synthesize b6;
@synthesize b7;

@synthesize c1;
@synthesize c2;
@synthesize c3;
@synthesize c4;
@synthesize c5;
@synthesize c6;
@synthesize c7;

@synthesize d1;
@synthesize d2;
@synthesize d3;
@synthesize d4;
@synthesize d5;
@synthesize d6;
@synthesize d7;

@synthesize e1;
@synthesize e2;
@synthesize e3;
@synthesize e4;
@synthesize e5;
@synthesize e6;
@synthesize e7;

@synthesize f1;
@synthesize f2;
@synthesize f3;
@synthesize f4;
@synthesize f5;
@synthesize f6;
@synthesize f7;

@synthesize g1;
@synthesize g2;
@synthesize g3;
@synthesize g4;
@synthesize g5;
@synthesize g6;
@synthesize g7;

@synthesize h1;
@synthesize h2;
@synthesize h3;
@synthesize h4;
@synthesize h5;
@synthesize h6;
@synthesize h7;

@synthesize i1;
@synthesize i2;
@synthesize i3;
@synthesize i4;
@synthesize i5;
@synthesize i6;
@synthesize i7;

@synthesize bestScore;
@synthesize winPopup;
@synthesize gameOverText;
@synthesize numberOfPegsLeft;

@synthesize retryButtonPopup;
@synthesize shuffleButtonPopup;

@synthesize welcomePopup;
@synthesize welcomeShuffleButton;

- (void) clearJumpTo
{
    
    for (int i = 0; i < buttonObjects.count; i++)
    {
        UIButton *button = [buttonObjects objectAtIndex:i];
        if (button.tag == JUMPTO)
        {
            button.tag = EMPTY;
            button.enabled = NO;
        }
    }
    
}

- (void)loadGame:(NSArray*)gameBoard
{    
    pressedButtonObject.enabled = YES;
    pressedButtonObject.selected = NO;
    pressedButtonObject.tag = PEG;
    activePeg = NO;
    
    [self clearJumpTo];
    
    for (int i = 0; i < [gameBoard count]; i++)
    {
        
        NSLog(@"%@", [gameBoard objectAtIndex:i]);
        NSLog(@"i: %i", i);
        
        if ([[gameBoard objectAtIndex:i] intValue] == 1)
        {
            UIButton *button = [buttonObjects objectAtIndex:i];
            [button setImage:[UIImage imageNamed:@"peg_red.png"] forState:(UIControlStateNormal)];
            button.enabled = YES;
            button.tag = PEG;
        }
        if ([[gameBoard objectAtIndex:i] intValue] == 0)
        {
            UIButton *button = [buttonObjects objectAtIndex:i];
            button.enabled = NO;
            button.tag = EMPTY;
        }
        
    }
    
}

- (int) countCurrentPegs
{
    int currentPegs = 0;
    
    for (int i = 0; i < buttonObjects.count; i++)
    {
        UIButton *button = [buttonObjects objectAtIndex:i];
        if (button.tag == PEG)
        {
            currentPegs++;
        }
    }
    return currentPegs;
}

- (void) newTopScore
{
    // pull old top score from the database
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *getBoardsAndScores = [defaults dictionaryRepresentation];
    NSMutableArray *boardsAndScores = [[getBoardsAndScores objectForKey:@"boardsAndScores"] mutableCopy];
    NSMutableDictionary *boardAndScoreObject = [[boardsAndScores objectAtIndex:gameBoardIndex] mutableCopy];
    NSString *topscore = [boardAndScoreObject objectForKey:@"topscore"];  
    
    NSLog(@"topscore in value: %i", [topscore intValue]);
    
    if ([topscore intValue] == 0)
    {
        NSString *topscoreString = [[NSString alloc] initWithFormat:@"%i", [self countCurrentPegs]];
        
        NSMutableArray *mutableBoardsAndScores = [boardsAndScores mutableCopy];
        NSMutableDictionary *topscore = [[mutableBoardsAndScores objectAtIndex:gameBoardIndex] mutableCopy];
        [topscore removeObjectForKey:@"topscore"];
        [topscore setObject:topscoreString forKey:@"topscore"];
        
        [mutableBoardsAndScores removeObjectAtIndex:gameBoardIndex];
        [mutableBoardsAndScores insertObject:topscore atIndex:gameBoardIndex];
        
        [defaults setObject:mutableBoardsAndScores forKey:@"boardsAndScores"];
        
        [defaults synchronize];
    }
    
    else if ([self countCurrentPegs] < [topscore intValue])
    {
        NSString *topscoreString = [[NSString alloc] initWithFormat:@"%i", [self countCurrentPegs]];
        
        NSMutableArray *mutableBoardsAndScores = [boardsAndScores mutableCopy];
        NSMutableDictionary *topscore = [[mutableBoardsAndScores objectAtIndex:gameBoardIndex] mutableCopy];
        [topscore removeObjectForKey:@"topscore"];
        [topscore setObject:topscoreString forKey:@"topscore"];
        
        [mutableBoardsAndScores removeObjectAtIndex:gameBoardIndex];
        [mutableBoardsAndScores insertObject:topscore atIndex:gameBoardIndex];
        
        [defaults setObject:mutableBoardsAndScores forKey:@"boardsAndScores"];
        
        [defaults synchronize];
    }
    
}

- (void) loadPopup
{
    // play game over sound
    
    // play sound
    SystemSoundID gameover;
    AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("sound_game_over"), CFSTR("wav"), NULL), &gameover);
    AudioServicesPlaySystemSound(gameover);
    
    
    winPopup.hidden = NO;
    [winPopup setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [winPopup setAlpha:1.0];
    [UIView commitAnimations];
    
    gameOverText.hidden = NO;
    [gameOverText setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [gameOverText setAlpha:1.0];
    [UIView commitAnimations];
    
    numberOfPegsLeft.hidden = NO;
    [numberOfPegsLeft setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [numberOfPegsLeft setAlpha:1.0];
    [UIView commitAnimations];
    
    // add custom font and update the text
    numberOfPegsLeft.font = [UIFont fontWithName:@"Cubano" size:28];
    numberOfPegsLeft.text = [[NSString alloc] initWithFormat:@"%i PEGS LEFT!", [self countCurrentPegs]];
    
    retryButtonPopup.hidden = NO;
    [retryButtonPopup setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [retryButtonPopup setAlpha:1.0];
    [UIView commitAnimations];
    
    shuffleButtonPopup.hidden = NO;
    [shuffleButtonPopup setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [shuffleButtonPopup setAlpha:1.0];
    [UIView commitAnimations];
}

- (BOOL) checkGameOver
{
    
    for (int i = 0; i < buttonObjects.count; i++)
    {
        UIButton *button = [buttonObjects objectAtIndex:i];
        if (button.tag == PEG)
        {
            if (i > 13)
            {
                // check if there's a peg above the pressed peg
                if ([[buttonObjects objectAtIndex:i-7] tag] == PEG)
                {
                    
                    UIButton *checkSpace = [buttonObjects objectAtIndex:i-14];
                    
                    // make sure there's a space available above that
                    if ([checkSpace tag] == EMPTY)
                    {
                        isGameOver = NO;
                        return NO;
                    }
                }
                
            }
            
            if ((i != 0) && (i != 1) && (i != 7) && (i != 8) && (i != 14) && (i != 15) && (i != 21) && (i != 22) && (i != 28) && (i != 29) && (i != 35) && (i != 36) && (i != 42) && (i != 43) && (i != 49) && (i != 50) && (i != 56) && (i != 57))
            {
                if (i > 1)
                {
                    // check if there's a peg to the left of the pressed peg
                    if ([[buttonObjects objectAtIndex:i-1] tag] == PEG)
                    {
                        
                        UIButton *checkSpace = [buttonObjects objectAtIndex:i-2];
                        
                        // make sure there's a space available to the left of that
                        if ([checkSpace tag] == EMPTY)
                        {
                            isGameOver = NO;
                            return NO;
                        }
                    }
                }
            }
            
            if ((i != 5) && (i != 6) && (i != 12) && (i != 13) && (i != 19) && (i != 20) && (i != 26) && (i != 27) && (i != 33) && (i != 34) && (i != 40) && (i != 41) && (i != 47) && (i != 48) && (i != 54) && (i != 55) && (i != 61) && (i != 62))
            {
                // check if there's a peg to the right of the pressed peg
                if ([[buttonObjects objectAtIndex:i+1] tag] == PEG)
                {
                    UIButton *checkSpace = [buttonObjects objectAtIndex:i+2];
                    
                    // make sure there's a space available to the right of that
                    if ([checkSpace tag] == EMPTY)
                    {
                        isGameOver = NO;
                        return NO;
                    }
                }
                
            }
            
            if (i < 48)
            {
                // check if there's a peg below of the pressed peg
                if ([[buttonObjects objectAtIndex:i+7] tag] == PEG)
                {
                    
                    UIButton *checkSpace = [buttonObjects objectAtIndex:i+14];
                    
                    // make sure there's a space available below of that
                    if ([checkSpace tag] == EMPTY)
                    {
                        isGameOver = NO;
                        return NO;
                    }
                }
            }
        }
    }
    
    isGameOver = YES;
    [self newTopScore];
    [self loadPopup];
    
    
    
    return isGameOver;
    
}

- (UIButton*) grabPegPressedObject
{
    
    for (int i = 0; i < buttonObjects.count; i++)
    {
        UIButton *button = [buttonObjects objectAtIndex:i];
        if (button.tag == PEGPRESSED)
        {
            NSLog(@"%i", button.tag);
            return button;
        }
    }

    return nil;
}

- (IBAction)buttonPressed:(UIButton*)sender
{

    // ok, you pressed the button. what's its deal?
    NSLog(@"%@", sender);
    
    // where is it in the array?
    NSLog(@"the index is: %i", [buttonObjects indexOfObject:sender]);
    
    if ([sender tag] == PEGPRESSED)
    {
        NSLog(@"are you getting in here?");
        sender.selected = NO;
        sender.tag = PEG;
        activePeg = NO;
        [self clearJumpTo];
    }
    
    else if ([sender tag] == JUMPTO)
    {
        
        NSLog(@"what about here?");
        int first = [buttonObjects indexOfObject:sender];
        int second = [buttonObjects indexOfObject:pressedButtonObject];
        
        NSLog(@"second: %i", second);
        
        // remove peg that's jumping
        UIButton *jumpingPeg = [buttonObjects objectAtIndex:second];
        jumpingPeg.tag = EMPTY;
        jumpingPeg.selected = NO;
        jumpingPeg.enabled = NO;
        [jumpingPeg setImage:[UIImage imageNamed:@"peg_empty.png"] forState:(UIControlStateDisabled)];
        
        // work out middle peg
        int middleNumber = (first + second) / 2;
        
        // remove jumped peg 
        UIButton *jumpedPeg = [buttonObjects objectAtIndex:middleNumber];
        jumpedPeg.tag = EMPTY;
        jumpedPeg.enabled = NO;
        
        // add new peg to jumped position
        sender.tag = PEG;
        sender.enabled = YES;
        [sender setImage:[UIImage imageNamed:@"peg_red.png"] forState:(UIControlStateNormal)];
        
        // reset active peg
        activePeg = NO;
        
        // remove other jump to pegs
        [self clearJumpTo];
        
        if ([self checkGameOver] == YES)
        {
            NSLog(@"GAME THE FUCK OVER!!!!!!!! Current pegs: %i", [self countCurrentPegs]);
        }
        else 
        {
            // play sound
            SystemSoundID jump;
            AudioServicesCreateSystemSoundID(CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("sound_jump"), CFSTR("wav"), NULL), &jump);
            AudioServicesPlaySystemSound(jump);
        }
    }
    
    else if ([sender tag] == PEG)
    {
        NSLog(@"PEG PRESSED!");
        
        if (pressedButtonObject.tag == PEGPRESSED)
        {
            pressedButtonObject.tag = PEG;
            pressedButtonObject.selected = NO;
            activePeg = NO;
            [self clearJumpTo];
        }
        
        // changed pressed button object so we can remove it later
        pressedButtonObject = sender;
        
        if (activePeg == NO)
        {
            // make state selected
            sender.selected = YES;
            sender.tag = PEGPRESSED;

            activePeg = YES;
        }

        int pressedPeg = [buttonObjects indexOfObject:sender];
        
        NSLog(@"%i", pressedPeg);
        
        // check if top two rows
        if (pressedPeg > 13)
        {
            // check if there's a peg above the pressed peg
            if ([[buttonObjects objectAtIndex:pressedPeg-7] tag] == PEG)
            {
                
                UIButton *checkSpace = [buttonObjects objectAtIndex:pressedPeg-14];
                
                // make sure there's a space available above that
                if ([checkSpace tag] == EMPTY)
                {
                    checkSpace.enabled = YES;
                    checkSpace.tag = JUMPTO;
                    [checkSpace setImage:[UIImage imageNamed:@"peg_glow.png"] forState:(UIControlStateNormal)];
                }
            }

        }
        
        if ((pressedPeg != 0) && (pressedPeg != 1) && (pressedPeg != 7) && (pressedPeg != 8) && (pressedPeg != 14) && (pressedPeg != 15) && (pressedPeg != 21) && (pressedPeg != 22) && (pressedPeg != 28) && (pressedPeg != 29) && (pressedPeg != 35) && (pressedPeg != 36) && (pressedPeg != 42) && (pressedPeg != 43) && (pressedPeg != 49) && (pressedPeg != 50) && (pressedPeg != 56) && (pressedPeg != 57))
        {
            if (pressedPeg > 1)
            {
                // check if there's a peg to the left of the pressed peg
                if ([[buttonObjects objectAtIndex:pressedPeg-1] tag] == PEG)
                {
                    
                    UIButton *checkSpace = [buttonObjects objectAtIndex:pressedPeg-2];
                    
                    // make sure there's a space available to the left of that
                    if ([checkSpace tag] == EMPTY)
                    {
                        checkSpace.enabled = YES;
                        checkSpace.tag = JUMPTO;
                        [checkSpace setImage:[UIImage imageNamed:@"peg_glow.png"] forState:(UIControlStateNormal)];
                    }
                }
            }
        }
        
        if ((pressedPeg != 5) && (pressedPeg != 6) && (pressedPeg != 12) && (pressedPeg != 13) && (pressedPeg != 19) && (pressedPeg != 20) && (pressedPeg != 26) && (pressedPeg != 27) && (pressedPeg != 33) && (pressedPeg != 34) && (pressedPeg != 40) && (pressedPeg != 41) && (pressedPeg != 47) && (pressedPeg != 48) && (pressedPeg != 54) && (pressedPeg != 55) && (pressedPeg != 61) && (pressedPeg != 62))
        {
            // check if there's a peg to the right of the pressed peg
            if ([[buttonObjects objectAtIndex:pressedPeg+1] tag] == PEG)
            {
                UIButton *checkSpace = [buttonObjects objectAtIndex:pressedPeg+2];
                
                // make sure there's a space available to the right of that
                if ([checkSpace tag] == EMPTY)
                {
                    checkSpace.enabled = YES;
                    checkSpace.tag = JUMPTO;
                    [checkSpace setImage:[UIImage imageNamed:@"peg_glow.png"] forState:(UIControlStateNormal)];
                }
            }
            
        }
        
        if (pressedPeg < 49)
        {
            // check if there's a peg below of the pressed peg
            if ([[buttonObjects objectAtIndex:pressedPeg+7] tag] == PEG)
            {
                
                UIButton *checkSpace = [buttonObjects objectAtIndex:pressedPeg+14];
                
                // make sure there's a space available below of that
                if ([checkSpace tag] == EMPTY)
                {
                    checkSpace.enabled = YES;
                    checkSpace.tag = JUMPTO;
                    [checkSpace setImage:[UIImage imageNamed:@"peg_glow.png"] forState:(UIControlStateNormal)];
                }
            }
        }
    }
    
}

- (void)loadButtonObjects
{
    buttonObjects = [[NSArray alloc] initWithObjects:a1, a2, a3, a4, a5, a6, a7,
                                                     b1, b2, b3, b4, b5, b6, b7,
                                                     c1, c2, c3, c4, c5, c6, c7,
                                                     d1, d2, d3, d4, d5, d6, d7,
                                                     e1, e2, e3, e4, e5, e6, e7,
                                                     f1, f2, f3, f4, f5, f6, f7, 
                                                     g1, g2, g3, g4, g5, g6, g7, 
                                                     h1, h2, h3, h4, h5, h6, h7,
                                                     i1, i2, i3, i4, i5, i6, i7, nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)checkAndUpdateScore:(NSString*)topscore
{

    if ([topscore intValue] != 0)
    {
        bestScore.text = [[NSString alloc] initWithFormat:@"Best Score: %i", [topscore intValue]];
    }
    else 
    {
        bestScore.text = @"";
    }
    bestScore.font = [UIFont fontWithName:@"Cubano" size:16];
}

- (void) unloadPopup
{
    winPopup.hidden = YES;
    gameOverText.hidden = YES;
    numberOfPegsLeft.hidden = YES;
    
    retryButtonPopup.hidden = YES;
    shuffleButtonPopup.hidden = YES;
}

- (void)loadRandomGame
{
    [self unloadPopup];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *getBoardsAndScores = [defaults dictionaryRepresentation];
    NSArray *boardsAndScores = [getBoardsAndScores objectForKey:@"boardsAndScores"];
    
    int aRandom;
    while ((aRandom = arc4random()%boardsAndScores.count) == gameBoardIndex);
        
    NSDictionary *boardAndScoreObject = [boardsAndScores objectAtIndex:aRandom];
    
    NSArray *gameBoard = [boardAndScoreObject objectForKey:@"gameboard"];    
    NSString *topscore = [boardAndScoreObject objectForKey:@"topscore"];
    
    [self checkAndUpdateScore:topscore];
    [self loadButtonObjects];
    [self loadGame:gameBoard];
    
    gameBoardIndex = [boardsAndScores indexOfObject:boardAndScoreObject];
    
    NSLog(@"gameboardindex: %i", gameBoardIndex);
    
}

- (IBAction)restartGame
{
    [self unloadPopup];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *getBoardsAndScores = [defaults dictionaryRepresentation];
    NSArray *boardsAndScores = [getBoardsAndScores objectForKey:@"boardsAndScores"];
    
    NSDictionary *boardAndScoreObject = [boardsAndScores objectAtIndex:gameBoardIndex];
    
    NSArray *gameBoard = [boardAndScoreObject objectForKey:@"gameboard"];   
    NSString *topscore = [boardAndScoreObject objectForKey:@"topscore"]; 
    
    [self checkAndUpdateScore:topscore];
    [self loadGame:gameBoard];
    
}

- (IBAction)shuffleGame
{
    welcomePopup.hidden = YES;
    welcomeShuffleButton.hidden = YES;
    
    [self loadRandomGame];
}

- (void) checkIfFirstUserAndDisplayWelcomePopup
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *getFirstUser = [defaults dictionaryRepresentation];
    NSString *firstUser = [getFirstUser objectForKey:@"first"];
    
    if ([firstUser intValue] != 1)
    {
        
        welcomePopup.hidden = NO;
        welcomeShuffleButton.hidden = NO;
        
        [defaults setObject:@"1" forKey:@"first"];
        [defaults synchronize];
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [self checkIfFirstUserAndDisplayWelcomePopup];
    
    NSArray *boardsAndScoresArray = [[NSArray alloc] initWithObjects:
                                            [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [[NSArray alloc] initWithObjects:
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                              @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                              @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                              @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                              @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                            [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [[NSArray alloc] initWithObjects:
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                              @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                              @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                              @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                              @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                              @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"1", @"0", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"1", @"1", @"1", @"0", @"1", @"1", @"1", 
                                               @"1", @"1", @"1", @"1", @"1", @"1", @"1", 
                                               @"1", @"1", @"1", @"1", @"1", @"1", @"1", 
                                               @"0", @"1", @"1", @"0", @"1", @"1", @"0", 
                                               @"0", @"0", @"1", @"0", @"1", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"1", @"0", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil],
                                             [[NSDictionary alloc] initWithObjectsAndKeys:
                                              [[NSArray alloc] initWithObjects:
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"1", @"0", @"0", @"0", @"1", @"0", 
                                               @"0", @"1", @"1", @"1", @"1", @"1", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"1", @"1", @"1", @"0", @"0", 
                                               @"0", @"0", @"0", @"0", @"0", @"0", @"0", nil], @"gameboard", @"topscore", @"0", nil], nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *getBoardsAndScores = [defaults dictionaryRepresentation];
    NSArray *boardsAndScores = [getBoardsAndScores objectForKey:@"boardsAndScores"];
    
    if (boardsAndScores.count < boardsAndScoresArray.count)
    {
        NSLog(@"here5");
        [defaults setObject:boardsAndScoresArray forKey:@"boardsAndScores"];
        [defaults synchronize];
    }
    
    [self loadRandomGame];

    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
