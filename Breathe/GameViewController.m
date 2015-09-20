//
//  GameViewController.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "GameViewController.h"
#import "BRTreeBranch.h"
#import "BRConnectionManager.h"
#import <QuartzCore/QuartzCore.h>

#define kUpdateInteval (1/30.0)

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
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateInteval target:self selector:@selector(updateTree:) userInfo:nil repeats:YES];
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
    if(iterations <= 450){
        iterations++;

        if(iterations ==450){
            [self resetTree];
            iterations = 0;
            return;
        }
        if(iterations > 400){
            return;
        }
    }


    BRConnectionManager *connectionManager = [BRConnectionManager sharedInstance];

    if(iterations % 40 == 0){

        NSMutableArray *newLatestBranches = [NSMutableArray array];
        for (BRTreeBranch *treeBranch in self.latestBranches) {
            int numberOfBranches = [self random] * 2 + 1;
            for (int i = 0; i < numberOfBranches; i++) {
                BRTreeBranch *newTreeBranch = [BRTreeBranch generateTreeBranchWithThickness:treeBranch.thickness.intValue length:1 angle:(M_PI_2) + ([self random] * M_PI_4 * [self randomSign])];
                if([self random] > 0.95){
                    newTreeBranch.hasFlower = YES;
                }
                [newLatestBranches addObject:newTreeBranch];
                [treeBranch.subBranches addObject:newTreeBranch];
            }
        }
        self.latestBranches = newLatestBranches;
        [connectionManager acknowledgeBreatheCycle];
    }else {
        for (BRTreeBranch *treeBranch in self.latestBranches) {
            treeBranch.length = @(treeBranch.length.intValue + 3 * fabs(sin(2*iterations * kUpdateInteval)));
        }
    }


    self.treeBranchView.treeBranch = self.treeStomp;
    [self.treeBranchView setNeedsDisplay];
}

@end
