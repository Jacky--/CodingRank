//
//  DebugView.h
//  CodingRank
//
//  Created by 吴家振 on 15/7/13.
//  Copyright (c) 2015年 Jacky--. All rights reserved.
//

#import <UIKit/UIKit.h>
//make sure only work on simluator
#if (defined __i386__) || (defined __x86_64__)
@interface DebugViewApp : UIApplication
@end

@interface DebugView : UIView {
    UIView      *_topView;
    UIView      *_container;
    UIView      *_view;
    UILabel		*_label;
    
    struct {
        unsigned int help:1;
        unsigned int width:1;
        unsigned int cmdMode:1;
    } _switches;
    
    CGPoint     _offset;
    
    UniChar	_lastCode;
    int		_velocity;
    CGPoint _location;
    BOOL	_isMoved;
}

+ (DebugView*)sharedInstance;
- (BOOL)isStarted;
- (void)start:(UIView*)view;
- (void)stop;
- (void)inputChar:(UniChar)keyCode flag:(int)flag;
@end

#endif
