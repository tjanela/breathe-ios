//
//  DeviceViewController.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceViewController : UIViewController

@property (strong) IBOutlet UIButton *openWebViewController;
@property (strong) IBOutlet UIButton *openGameViewController;

- (IBAction)dataButton_touchUpInside:(id)sender;
- (IBAction)gameButton_touchUpInside:(id)sender;

@end
