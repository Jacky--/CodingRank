//
//  JNetworkAgent.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/10.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JNetworkAgent.h"

void JLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}

@implementation JNetworkAgent{
    AFHTTPRequestOperationManager *_manager;
    NSMutableDictionary * _requestsRecord;
}

+ (JNetworkAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPRequestOperationManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
    }
    return self;
}

- (NSString *)buildRequestUrl:(JBaseRequest *)request
{
    NSString *detailUrl = request.requestUrl;
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    NSString *baseUrl;
    if (request.baseUrl.length > 0) {
        baseUrl = request.baseUrl;
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(JBaseRequest *)request
{
    JRequestMethod method = request.requestMethod;
    NSString *url = [self buildRequestUrl:request];
    NSDictionary *param = request.requestParam;
    if (request.requestSerializerType == JRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == JRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (method == JRequestMethodGet) {
        request.requestOperation = [_manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (method == JRequestMethodPost) {
        request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (method == JRequestMethodHead) {
        request.requestOperation = [_manager HEAD:url parameters:param success:^(AFHTTPRequestOperation *operation) {
            [self handleRequestResult:operation];
        }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (method == JRequestMethodPut) {
        request.requestOperation = [_manager PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else if (method == JRequestMethodDelete) {
        request.requestOperation = [_manager DELETE:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self handleRequestResult:operation];
        }                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self handleRequestResult:operation];
        }];
    } else {
        JLog(@"Error, unsupport method type");
        return;
    }
    JLog(@"Add request: %@", NSStringFromClass([request class]));
    [self addOperation:request];
}

- (void)cancelRequest:(JBaseRequest *)request
{
    [request.requestOperation cancel];
    [self removeOperation:request.requestOperation];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests
{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        JBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (BOOL)checkResult:(JBaseRequest *)request
{
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    return result;
}

- (void)handleRequestResult:(AFHTTPRequestOperation *)operation
{
    NSString *key = [self requestHashKey:operation];
    JBaseRequest *request = _requestsRecord[key];
    JLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
        } else {
            JLog(@"Request %@ failed, status code = %ld", NSStringFromClass([request class]), (long)request.responseStatusCode);
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

- (void)addOperation:(JBaseRequest *)request
{
    if (request.requestOperation != nil) {
        NSString *key = [self requestHashKey:request.requestOperation];
        _requestsRecord[key] = request;
    }
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation
{
    NSString *key = [self requestHashKey:operation];
    [_requestsRecord removeObjectForKey:key];
    JLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end
