//
//  BRTreeBranchView.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "BRTreeBranchView.h"

@implementation BRTreeBranchView

- (void) setBackgroundIntensity:(CGFloat)backgroundIntensity{
    _backgroundIntensity = backgroundIntensity;
    CGFloat darkBlueRed = 0x0b / 255.0f;
    CGFloat darkBlueGreen = 0x3e / 255.0f;
    CGFloat darkBlueBlue = 0x58 / 255.0f;

    CGFloat lightBlueRed = 0x15 / 255.0f;
    CGFloat lightBlueGreen = 0x62 / 255.0f;
    CGFloat lightBlueBlue = 0xac / 255.0f;

    UIColor *backgroundColor = [UIColor colorWithRed:darkBlueRed + (lightBlueRed - darkBlueRed) * backgroundIntensity
                                               green:darkBlueGreen + (lightBlueGreen - darkBlueGreen) * backgroundIntensity
                                                blue:darkBlueBlue + (lightBlueBlue - darkBlueBlue) * backgroundIntensity
                                               alpha:1];

    self.backgroundColor = backgroundColor;
}

- (CGFloat) backgroundIntensity{
    return _backgroundIntensity;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] colorWithAlphaComponent:0.3].CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    [self drawTreeBranch:self.treeBranch atX:self.frame.size.width / 2 atY:self.frame.size.height withContext:context];

    CGContextStrokePath(context);
}

- (void) drawTreeBranch:(BRTreeBranch*)treeBranch atX:(int)x atY:(int)y withContext:(CGContextRef)context{

    CGContextSetLineWidth(context, treeBranch.thickness.integerValue);
    CGContextMoveToPoint(context, x, y);

    double endX = treeBranch.length.intValue * cos(treeBranch.angle.doubleValue);
    double endY = treeBranch.length.intValue * sin(treeBranch.angle.doubleValue);

    CGContextAddLineToPoint(context, x + endX, y - endY);

    for (BRTreeBranch *subTreeBranch in treeBranch.subBranches) {
        [self drawTreeBranch:subTreeBranch atX:x + endX atY:y - endY withContext:context];
    }
}

@end
