//
//  BRTreeBranch.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "BRTreeBranch.h"

@implementation BRTreeBranch

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.length = @(0);
        self.angle = @(M_PI_2);
        self.thickness = @(1);
        self.subBranches = [NSMutableArray array];
    }
    return self;
}


+(BRTreeBranch*) generateTreeBranchWithThickness:(int)thickness length:(int)length angle:(double)angle{
    BRTreeBranch *treeBranch = [[BRTreeBranch alloc] init];
    treeBranch.thickness = @(thickness);
    treeBranch.length = @(length);
    treeBranch.angle = @(angle);
    return treeBranch;
}

@end
