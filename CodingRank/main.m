//
//  main.m
//  CodingRank
//
//  Created by 吴家振 on 15/7/10.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#if (defined __i386__) || (defined __x86_64__)
#import "DebugView.h"
#endif

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
#if (defined __i386__) || (defined __x86_64__)
        return UIApplicationMain(argc, argv, @"DebugViewApp", NSStringFromClass([AppDelegate class]));
#else
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#endif
    }
}
