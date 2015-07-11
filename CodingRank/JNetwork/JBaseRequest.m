//
//  JBaseRequest.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/10.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JBaseRequest.h"
#import "JNetworkAgent.h"

@implementation JBaseRequest

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)responseStatusCode
{
    return self.requestOperation.response.statusCode;
}

- (id)responseJSONObject
{
    return self.requestOperation.responseObject;
}

- (NSString *)responseString
{
    return self.requestOperation.responseString;
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(JBaseRequest *request))success
                                    failure:(void (^)(JBaseRequest *request))failure
{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(JBaseRequest *request))success
                              failure:(void (^)(JBaseRequest *request))failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

//append self to request queue
- (void)start
{
    [[JNetworkAgent sharedInstance] addRequest:self];
}

//remove self from request queue
- (void)stop
{
    self.delegate = nil;
    [[JNetworkAgent sharedInstance] cancelRequest:self];
}

- (void)clearCompletionBlock
{
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

@end
