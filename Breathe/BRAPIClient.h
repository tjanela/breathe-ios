//
//  BRAPIClient.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface BRAPIClient : AFHTTPSessionManager

+ (BRAPIClient *) sharedInstance;

- (void) postMeasurements:(NSArray*)measurement success:(void(^)())successBlock error:(void(^)())errorBlock;

- (void) setUserId:(NSString*)userId;

@end
