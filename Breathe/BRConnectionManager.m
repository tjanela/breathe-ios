//
//  BRConnectionManager.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "BRConnectionManager.h"
#import "RigAvailableDeviceData.h"
#import "Constants.h"
#import "BRAPIClient.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BRConnectionManager

+ (BRConnectionManager*) sharedInstance{
    static BRConnectionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[RigLeConnectionManager sharedInstance] setDelegate:self];

        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        self.measurementsArray = [NSMutableArray array];
        _networkDispatcher = [NSTimer scheduledTimerWithTimeInterval:kDispatchPeriod target:self selector:@selector(networkDispatcher_timerFired:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) networkDispatcher_timerFired:(id)sender {
    @synchronized(self) {
        if(self.measurementsArray.count == 0){
            NSLog(@"No data to upload");
            return;
        }
        NSLog(@"Data length: %lu", self.measurementsArray.count);
        NSUInteger length = MIN(self.measurementsArray.count, 10);
        NSArray *array = [self.measurementsArray subarrayWithRange:NSMakeRange(0, length)];
        [[BRAPIClient sharedInstance] postMeasurements:array success:^{
            NSLog(@"Success");
            

        } error:^{
            NSLog(@"Error");

        }];
    }
}

- (void) connectToDevice:(RigAvailableDeviceData*)deviceData {
    [[RigLeConnectionManager sharedInstance] connectDevice:deviceData connectionTimeout:kTimeout];
}

- (void)didConnectDevice:(RigLeBaseDevice*)device {
    NSLog(@"Device Connected");
    device.delegate = self;
    [device runDiscovery];
}
- (void)didDisconnectPeripheral:(CBPeripheral*)peripheral {
    NSLog(@"Did Disconnect Peripheral");
}
- (void)deviceConnectionDidFail:(RigAvailableDeviceData*)device {
    NSLog(@"Device Connection Fail");
}
- (void)deviceConnectionDidTimeout:(RigAvailableDeviceData*)device {
    NSLog(@"Device Connection did Timeout");
}

- (void)discoveryDidCompleteForDevice:(RigLeBaseDevice*)device {
    NSArray* serviceList = [device getSerivceList];
    for(CBService *service in serviceList) {
        NSLog(@"Service: %@", [service.UUID UUIDString]);
        NSArray *characteristics = service.characteristics;
        for(CBCharacteristic *characteristic in characteristics) {
            [device enableNotificationsForCharacteristic:characteristic];
        }
    }
}
- (void)didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic forDevice:(RigLeBaseDevice*)device {
    NSData *data = characteristic.value;

    NSLog(@"Value update: %lu bytes", (unsigned long)data.length);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    BytePtr dataBytes = (BytePtr) data.bytes;
    UInt32 packetId = 0;
    UInt16 ekg = 0;
    UInt16 chest = 0;
    UInt16 belly = 0;
    SInt8 aX = 0;
    SInt8 aY = 0;
    SInt8 aZ = 0;
    SInt8 gX = 0;
    SInt8 gY = 0;
    SInt8 gZ = 0;
    //000000b3 0b780fff 0ffff707 c9030101
    NSLog(@"Value Bytes: %@", [data description]);

    packetId |= (dataBytes[0] << 24);
    packetId |= (dataBytes[1] << 16);
    packetId |= (dataBytes[2] << 8);
    packetId |= (dataBytes[3] << 0);

    if(packetId == 0) {
        _packet0Epoch = [[NSDate date] timeIntervalSince1970];
    }

    ekg |= (dataBytes[4] << 8);
    ekg |= (dataBytes[5]);

    chest |= ((dataBytes[6] << 8) & 0b00001111);
    chest |= (dataBytes[7]);

    belly |= ((dataBytes[8] << 8) & 0b00001111);
    belly |= (dataBytes[9]);

    aX = dataBytes[10];
    aY = dataBytes[11];
    aZ = dataBytes[12];

    gX = dataBytes[13];
    gY = dataBytes[14];
    gZ = dataBytes[15];

    dictionary[@"sid"] = @(packetId);
    dictionary[@"ekg"] = @(ekg);
    dictionary[@"breath_chest"] = @(chest);
    dictionary[@"breath_belly"] = @(belly);
    dictionary[@"accel_x"] = @(aX);
    dictionary[@"accel_y"] = @(aY);
    dictionary[@"accel_z"] = @(aZ);
    dictionary[@"gyro_x"] = @(gX);
    dictionary[@"gyro_y"] = @(gY);
    dictionary[@"gyro_z"] = @(gZ);
    dictionary[@"measured_at"] = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_packet0Epoch + (packetId * kSamplePeriod)]];

    @synchronized(self) {
        [self.measurementsArray addObject:dictionary];
    }

    NSUInteger bellyValue = belly;
    NSUInteger chestValue = chest;
    NSInteger newBellySlope = 0;
    NSInteger newChestSlope = 0;

    if(packetId == 0){
        _lastBellyValue = belly;
        _lastChestValue = chest;
        _currentBellySlope = 0;
        _currentChestSlope = 0;
        _inhaleBellyAccumulator = 0;
        _exhaleBellyAccumulator = 0;
        _inhaleChestAccumulator = 0;
        _exhaleChestAccumulator = 0;
        _currentChestAverage = 0;
        _currentBellyAverage = 0;
    }
    else {
        //Calculate current slope
        newBellySlope = belly - bellyValue;
        newChestSlope = chest - chestValue;
        //Accumulate properly

        if(signbit(newBellySlope) != signbit(_currentBellySlope)) {
            if(newBellySlope >= 0){
                _inhaleBellyAccumulator = (bellyValue * kSamplePeriod);
            }
            else {
                _exhaleBellyAccumulator = (bellyValue * kSamplePeriod);
            }
        } else {
            if(newBellySlope >= 0){
                _inhaleBellyAccumulator += (bellyValue * kSamplePeriod);
            }
            else {
                _exhaleBellyAccumulator += (bellyValue * kSamplePeriod);
            }
        }

        if(signbit(newChestSlope) != signbit(_currentChestSlope)) {
            if(newChestSlope >= 0){
                _inhaleChestAccumulator = (chestValue * kSamplePeriod);
                if(_didInhale){
                    _breatheCycleComplete = YES;
                    _didInhale = NO;
                }
            }
            else {
                if(!_didInhale){
                    _didInhale = YES;
                }
                _exhaleChestAccumulator = (chestValue * kSamplePeriod);
            }
        } else {
            if(newChestSlope >= 0){
                _inhaleChestAccumulator += (chestValue * kSamplePeriod);
            }
            else {
                _exhaleChestAccumulator += (chestValue * kSamplePeriod);
            }
        }


        double currentBellyAverage = (bellyValue + (_currentBellyAverage * (packetId - 1))) / packetId;
        double currentChestAverage = (chestValue + (_currentChestAverage * (packetId - 1))) / packetId;

        _currentBellyAverage = currentBellyAverage;
        _currentChestAverage = currentChestAverage;
    }

    _currentBellySlope = newBellySlope;
    _currentChestSlope = newChestSlope;


    NSLog(@"Packet: %@", dictionary);
}

- (double) bellyRatio{
    return (_lastBellyValue) * 1.0
    /
    (_currentBellyAverage);
}

- (void)acknowledgeBreatheCycle{
    _breatheCycleComplete = NO;
}

- (void)didUpdateNotifyStateForCharacteristic:(CBCharacteristic*)characteristic forDevice:(RigLeBaseDevice*)device {
    NSLog(@"Notify State");
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceConnectedNotificationName object:nil];
    
}

- (void)didWriteValueForCharacteristic:(CBCharacteristic*)characteristic forDevice:(RigLeBaseDevice*)device {
    NSLog(@"Write Value");
}
@end
