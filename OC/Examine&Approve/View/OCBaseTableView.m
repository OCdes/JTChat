//
//  OCBaseTableView.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/4.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "OCBaseTableView.h"

@implementation OCBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        if (@available(iOS 13.0, *)) {
            self.automaticallyAdjustsScrollIndicatorInsets = NO;
        } else {
            // Fallback on earlier versions
            if (@available(iOS 11.0, *)) {
                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
