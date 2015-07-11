//
//  JNetworkAgent.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/10.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBaseRequest.h"
#import "AFNetworking.h"

FOUNDATION_EXPORT void JLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface JNetworkAgent : NSObject

+ (JNetworkAgent *)sharedInstance;
- (void)addRequest:(JBaseRequest *)request;
- (void)cancelRequest:(JBaseRequest *)request;
- (void)cancelAllRequests;

@end
