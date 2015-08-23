//
//  UsersApi.h
//  CodingRank
//
//  Created by 吴家振 on 15/8/23.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import "JBaseRequest.h"

@interface UsersApi : JBaseRequest

- (id)initWithLocation:(NSString *)location andLanguage:(NSString *)language andPage:(NSString *)page;

@end
