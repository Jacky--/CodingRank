//
//  JBaseRequest.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/10.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger , JRequestMethod) {
    JRequestMethodGet = 0,
    JRequestMethodPost,
    JRequestMethodHead,
    JRequestMethodPut,
    JRequestMethodDelete,
};

typedef NS_ENUM(NSInteger , JRequestSerializerType) {
    JRequestSerializerTypeHTTP = 0,
    JRequestSerializerTypeJSON,
};

@class JBaseRequest;

@protocol JBaseRequestDelegate <NSObject>

- (void)requestFinished:(JBaseRequest *)request;
- (void)requestFailed:(JBaseRequest *)request;

@optional
- (void)clearRequest;

@end

@interface JBaseRequest : NSObject

@property (nonatomic) NSInteger tag;
@property (nonatomic) JRequestMethod requestMethod;
@property (nonatomic) JRequestSerializerType requestSerializerType;//请求的数据类型
@property (nonatomic, strong) AFHTTPRequestOperation *requestOperation;
@property (nonatomic, weak) id<JBaseRequestDelegate> delegate;
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
@property (nonatomic, strong, readonly) NSString *responseString;
@property (nonatomic, copy) NSString * baseUrl;//服务器地址BaseUrl
@property (nonatomic, copy) NSString * requestUrl;//请求的URL
@property (nonatomic, strong) NSDictionary * requestParam;//请求的参数
@property (nonatomic, strong, readonly) id responseJSONObject;
@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (nonatomic, copy) void (^successCompletionBlock)(JBaseRequest *);
@property (nonatomic, copy) void (^failureCompletionBlock)(JBaseRequest *);

// block回调
- (void)startWithCompletionBlockWithSuccess:(void (^)(JBaseRequest *request))success
                                    failure:(void (^)(JBaseRequest *request))failure;

- (void)setCompletionBlockWithSuccess:(void (^)(JBaseRequest *request))success
                              failure:(void (^)(JBaseRequest *request))failure;
// 把block置nil来打破循环引用
- (void)clearCompletionBlock;
// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;
- (void)stop;

@end
