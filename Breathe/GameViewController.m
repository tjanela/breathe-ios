//
//  GameViewController.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "GameViewController.h"
#import "BRTreeBranch.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()
{
    NSUInteger iterations;
}
@end

@implementation GameViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.latestBranches = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resetTree];
    if(self.updateTimer != nil){
        [self.updateTimer invalidate];
    }
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTree:) userInfo:nil repeats:YES];
}

- (void) resetTree{
    [self.latestBranches removeAllObjects];
    BRTreeBranch *treeBranch = [BRTreeBranch generateTreeBranchWithThickness:5 length:40 angle:M_PI_2];
    self.treeStomp = treeBranch;
    [self.latestBranches addObject:treeBranch];
    iterations = 0;
}

- (BRTreeBranchView *)treeBranchView{
    return (BRTreeBranchView*) self.view;
}
#define ARC4RANDOM_MAX      0x100000000

- (double) random{
    double val = ((double)arc4random() / ARC4RANDOM_MAX);
    return val;
}

- (double) randomSign{
    double val = (((double)arc4random() / ARC4RANDOM_MAX) - 0.5);
    return val < 0 ? -1 : 1;
}

- (void) updateTree:(id)sender{
    if(iterations > 10){
        [self resetTree];
    }
    iterations++;

    NSMutableArray *newLatestBranches = [NSMutableArray array];
    for (BRTreeBranch *treeBranch in self.latestBranches) {
        int numberOfBranches = [self random] * 2 + 1;
        for (int i = 0; i < numberOfBranches; i++) {
            BRTreeBranch *newTreeBranch = [BRTreeBranch generateTreeBranchWithThickness:treeBranch.thickness.intValue length:[self random] * 80 angle:(M_PI_2) + ([self random] * M_PI_4 * [self randomSign])];
            [newLatestBranches addObject:newTreeBranch];
            [treeBranch.subBranches addObject:newTreeBranch];
        }
    }
    self.latestBranches = newLatestBranches;

    self.treeBranchView.treeBranch = self.treeStomp;
    [self.treeBranchView setNeedsDisplay];
    CGFloat nextIntensity = 0;
    if(self.treeBranchView.backgroundIntensity == 0.0f){
        nextIntensity = 1;
    }
    [UIView animateWithDuration:0.9 animations:^{
        self.treeBranchView.backgroundIntensity = nextIntensity;
    }];
}

@end
