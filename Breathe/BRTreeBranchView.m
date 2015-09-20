//
//  BRTreeBranchView.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "BRTreeBranchView.h"

@implementation BRTreeBranchView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){

        CGFloat lightBlueRed = 0x15 / 255.0f;
        CGFloat lightBlueGreen = 0x62 / 255.0f;
        CGFloat lightBlueBlue = 0xac / 255.0f;

        _lightColor = [UIColor colorWithRed:lightBlueRed green:lightBlueGreen blue:lightBlueBlue alpha:1];

        CGFloat darkBlueRed = 0x0b / 255.0f;
        CGFloat darkBlueGreen = 0x3e / 255.0f;
        CGFloat darkBlueBlue = 0x58 / 255.0f;

        _darkColor = [UIColor colorWithRed:darkBlueRed green:darkBlueGreen blue:darkBlueBlue alpha:1];
    }
    return self;
}

- (void) setBackgroundIntensity:(CGFloat)backgroundIntensity{
    _backgroundIntensity = backgroundIntensity;

}

- (CGFloat) backgroundIntensity{
    return _backgroundIntensity;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [_darkColor colorWithAlphaComponent:0.3].CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    [self drawTreeBranch:self.treeBranch atX:self.frame.size.width / 2 atY:self.frame.size.height withContext:context];

    CGContextStrokePath(context);
}

- (void) drawTreeBranch:(BRTreeBranch*)treeBranch atX:(int)x atY:(int)y withContext:(CGContextRef)context{

    CGContextSetLineWidth(context, treeBranch.thickness.integerValue);
    CGContextMoveToPoint(context, x, y);

    if(treeBranch.hasFlower){
        UIImage *image = [UIImage imageNamed:@"flower"];
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, x + image.size.width / 2, y - image.size.height);
        CGContextRotateCTM(context, M_PI_4/2);
        [image drawAtPoint:CGPointMake(0, 0)];
        CGContextRestoreGState(context);
    }

    double endX = treeBranch.length.intValue * cos(treeBranch.angle.doubleValue);
    double endY = treeBranch.length.intValue * sin(treeBranch.angle.doubleValue);

    CGContextAddLineToPoint(context, x + endX, y - endY);

    for (BRTreeBranch *subTreeBranch in treeBranch.subBranches) {
        [self drawTreeBranch:subTreeBranch atX:x + endX atY:y - endY withContext:context];
    }
}

@end
