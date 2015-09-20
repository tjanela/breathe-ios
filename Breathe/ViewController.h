//
//  ViewController.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RigLeDiscoveryManager.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RigLeDiscoveryManagerDelegate>

@property (strong) IBOutlet UITableView* tableView;
@property (strong) IBOutlet UIButton* scanButton;
@property (strong) IBOutlet UIActivityIndicatorView* activityIndicatorView;

- (IBAction)scanDevices_touchUpInside:(id)sender;

@end

