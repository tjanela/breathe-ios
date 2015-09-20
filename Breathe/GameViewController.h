//
//  GameViewController.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRTreeBranchView.h"
#import "BRTreeBranch.h"

@interface GameViewController : UIViewController
@property (strong) NSMutableArray *latestBranches;
@property (strong) CAShapeLayer *shapeLayer;
@property (strong) NSTimer *updateTimer;
@property (readonly) BRTreeBranchView *treeBranchView;
@property (strong) BRTreeBranch *treeStomp;
@end
