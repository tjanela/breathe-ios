//
//  BRAPIClient.m
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import "BRAPIClient.h"
#import "Constants.h"

@implementation BRAPIClient

+ (BRAPIClient *)sharedInstance{
    static BRAPIClient *_sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });

    return _sharedInstance;
}

- (void) setUserId:(NSString*)userId{
    [self.requestSerializer setValue:userId forHTTPHeaderField:@"x-user-id"];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    return self;
}

- (void)postMeasurements:(NSArray *)measurements success:(void(^)())successBlock error:(void(^)())errorBlock
{
    [self POST:@"sensordata/"
    parameters:measurements
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           successBlock();
    }
       failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
           errorBlock();
    }];
}
@end
