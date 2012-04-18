//
//  ViewController.h
//  peg
//
//  Created by Jon Wheatley on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController
{
    NSArray *buttonObjects;
    UIButton *pressedButtonObject;
    NSArray *allGameBoards;
    int gameBoardIndex;
    BOOL activePeg;
    BOOL isGameOver;
}

// top row

@property (strong, retain) IBOutlet UIButton *a1;
@property (strong, retain) IBOutlet UIButton *a2;
@property (strong, retain) IBOutlet UIButton *a3;
@property (strong, retain) IBOutlet UIButton *a4;
@property (strong, retain) IBOutlet UIButton *a5;
@property (strong, retain) IBOutlet UIButton *a6;
@property (strong, retain) IBOutlet UIButton *a7;

// second row

@property (strong, retain) IBOutlet UIButton *b1;
@property (strong, retain) IBOutlet UIButton *b2;
@property (strong, retain) IBOutlet UIButton *b3;
@property (strong, retain) IBOutlet UIButton *b4;
@property (strong, retain) IBOutlet UIButton *b5;
@property (strong, retain) IBOutlet UIButton *b6;
@property (strong, retain) IBOutlet UIButton *b7;

// third row

@property (strong, retain) IBOutlet UIButton *c1;
@property (strong, retain) IBOutlet UIButton *c2;
@property (strong, retain) IBOutlet UIButton *c3;
@property (strong, retain) IBOutlet UIButton *c4;
@property (strong, retain) IBOutlet UIButton *c5;
@property (strong, retain) IBOutlet UIButton *c6;
@property (strong, retain) IBOutlet UIButton *c7;

// forth

@property (strong, retain) IBOutlet UIButton *d1;
@property (strong, retain) IBOutlet UIButton *d2;
@property (strong, retain) IBOutlet UIButton *d3;
@property (strong, retain) IBOutlet UIButton *d4;
@property (strong, retain) IBOutlet UIButton *d5;
@property (strong, retain) IBOutlet UIButton *d6;
@property (strong, retain) IBOutlet UIButton *d7;

// fifth

@property (strong, retain) IBOutlet UIButton *e1;
@property (strong, retain) IBOutlet UIButton *e2;
@property (strong, retain) IBOutlet UIButton *e3;
@property (strong, retain) IBOutlet UIButton *e4;
@property (strong, retain) IBOutlet UIButton *e5;
@property (strong, retain) IBOutlet UIButton *e6;
@property (strong, retain) IBOutlet UIButton *e7;

// sixth

@property (strong, retain) IBOutlet UIButton *f1;
@property (strong, retain) IBOutlet UIButton *f2;
@property (strong, retain) IBOutlet UIButton *f3;
@property (strong, retain) IBOutlet UIButton *f4;
@property (strong, retain) IBOutlet UIButton *f5;
@property (strong, retain) IBOutlet UIButton *f6;
@property (strong, retain) IBOutlet UIButton *f7;

// seventh

@property (strong, retain) IBOutlet UIButton *g1;
@property (strong, retain) IBOutlet UIButton *g2;
@property (strong, retain) IBOutlet UIButton *g3;
@property (strong, retain) IBOutlet UIButton *g4;
@property (strong, retain) IBOutlet UIButton *g5;
@property (strong, retain) IBOutlet UIButton *g6;
@property (strong, retain) IBOutlet UIButton *g7;

// 8th

@property (strong, retain) IBOutlet UIButton *h1;
@property (strong, retain) IBOutlet UIButton *h2;
@property (strong, retain) IBOutlet UIButton *h3;
@property (strong, retain) IBOutlet UIButton *h4;
@property (strong, retain) IBOutlet UIButton *h5;
@property (strong, retain) IBOutlet UIButton *h6;
@property (strong, retain) IBOutlet UIButton *h7;

// 9th

@property (strong, retain) IBOutlet UIButton *i1;
@property (strong, retain) IBOutlet UIButton *i2;
@property (strong, retain) IBOutlet UIButton *i3;
@property (strong, retain) IBOutlet UIButton *i4;
@property (strong, retain) IBOutlet UIButton *i5;
@property (strong, retain) IBOutlet UIButton *i6;
@property (strong, retain) IBOutlet UIButton *i7;

// best score ui

@property (strong, retain) IBOutlet UILabel *bestScore;

// popup

@property (strong, retain) IBOutlet UIImageView *winPopup;
@property (strong, retain) IBOutlet UIImageView *gameOverText;
@property (strong, retain) IBOutlet UILabel *numberOfPegsLeft;

@property (strong, retain) IBOutlet UIButton *retryButtonPopup;
@property (strong, retain) IBOutlet UIButton *shuffleButtonPopup;

// welcome 

@property (strong, retain) IBOutlet UIImageView *welcomePopup;
@property (strong, retain) IBOutlet UIButton *welcomeShuffleButton;


- (IBAction)buttonPressed:(UIButton*)sender;
- (IBAction)shuffleGame;
- (IBAction)restartGame;

@end
