//
//  RootViewController.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "ViewController.h"
#import "RigDeviceRequest.h"
#import "RigLeBaseDevice.h"
#import "RigLeDiscoveryManager.h"
#import "RigLeConnectionManager.h"
#import "Constants.h"
#import "BRConnectionManager.h"
#import <NSThreadBlocks/NSThread+Blocks.h>

#define kTimeout 15

@interface ViewController ()

@property (strong) NSMutableArray *devicesArray;
@property (strong) RigAvailableDeviceData *connectedDevice;
@property (strong) NSTimer *centralManagerReadyTimer;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.devicesArray = [NSMutableArray array];
        [[RigLeDiscoveryManager sharedInstance] startLeInterface];
        self.scanButton.enabled = YES;
        self.centralManagerReadyTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(centralManagerReadyTimer_fired:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) centralManagerReadyTimer_fired:(id) sender {

}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (IBAction)scanDevices_touchUpInside:(id)sender{
    if(![[RigLeDiscoveryManager sharedInstance] isDiscoveryRunning]){
        self.scanButton.enabled = NO;
        [self.activityIndicatorView startAnimating];
        RigDeviceRequest *request = [RigDeviceRequest deviceRequestWithUuidList:@[] timeout:kTimeout delegate:self allowDuplicates:NO];
        [[RigLeDiscoveryManager sharedInstance] discoverDevices:request];
    } else {

    }
}

#pragma mark RigLeDeviceManagerDelegate -

- (void)didDiscoverDevice:(RigAvailableDeviceData*)device
{
    [NSThread performBlockOnMainThread:^{
        self.devicesArray = [NSMutableArray arrayWithArray:[[RigLeDiscoveryManager sharedInstance] retrieveDiscoveredDevices]];
        [self.tableView reloadData];
    }];
}

- (void)discoveryDidTimeout
{
    self.scanButton.enabled = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)bluetoothNotPowered
{
}

- (void)didUpdateDeviceData:(RigAvailableDeviceData*)device deviceIndex:(NSUInteger)index
{
    [NSThread performBlockOnMainThread:^{
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicesArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RigAvailableDeviceData *deviceData = [self.devicesArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSDictionary *dict = deviceData.advertisementData;
    //NSLog(@"AdvertisementData: %@", dict);
    if(deviceData.peripheral.name != nil && ![@"" isEqualToString:deviceData.peripheral.name]){
        cell.textLabel.text = deviceData.peripheral.name;
    }else {
        cell.textLabel.text = @"n.a.";
    }
    return cell;
}

#pragma mark UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.connectedDevice = [self.devicesArray objectAtIndex:indexPath.row];

    [[BRConnectionManager sharedInstance] connectToDevice:self.connectedDevice];
}

@end
