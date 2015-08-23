//
//  UsersApi.m
//  CodingRank
//
//  Created by 吴家振 on 15/8/23.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "UsersApi.h"

@implementation UsersApi
{
    NSString *_location;
    NSString *_page;
}

- (id)initWithLocation:(NSString *)location andLanguage:(NSString *)language andPage:(NSString *)page
{
    self = [super init];
    if (self) {
        _location = [NSString stringWithFormat:@"location:%@",location];
        _page = page;
    }
    return self;
}

- (NSString *)baseUrl
{
    return JBaseHostUrl;
}

- (NSString *)requestUrl
{
    return @"/search/users?q=location:china&sort=followers&page=1";
}

- (JRequestMethod)requestMethod
{
    return JRequestMethodGet;
}

//https://api.github.com/search/users?q=location:shenzhen&sort=followers&page=1
//https://api.github.com/search/users?q=location:shenzhen+language:JavaScript&sort=followers&page=1
//- (NSDictionary *)requestParam
//{
//    return @{
//             @"q": _location,
//             @"sort":@"followers",
//             @"page":_page
//             };
//}


@end
