//
//  BRTreeBranch.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BRTreeBranch : NSObject

@property (strong) NSNumber *length;
@property (strong) NSNumber *angle;
@property (strong) NSNumber *thickness;
@property (strong) NSMutableArray *subBranches;
@property (assign) BOOL hasFlower;

+ (BRTreeBranch*) generateTreeBranchWithThickness:(int)thickness length:(int)length angle:(double)angle;

@end