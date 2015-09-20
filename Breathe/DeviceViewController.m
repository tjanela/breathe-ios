//
//  DeviceViewController.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "DeviceViewController.h"

@implementation DeviceViewController

- (void)dataButton_touchUpInside:(id)sender{
    [self performSegueWithIdentifier:@"OpenData" sender:self];
}
- (void)gameButton_touchUpInside:(id)sender{
    [self performSegueWithIdentifier:@"OpenGame" sender:self];
}

@end
