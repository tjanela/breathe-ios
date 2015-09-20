//
//  BRTreeBranchView.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRTreeBranch.h"

@interface BRTreeBranchView : UIView
{
    CGFloat _backgroundIntensity;
    UIColor *_lightColor;
    UIColor *_darkColor;
}

@property (strong) BRTreeBranch *treeBranch;
@property (assign) CGFloat backgroundIntensity;

@end
