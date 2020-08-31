//
//  SigleTimeSelectView.h
//  JingTeYuHui
//
//  Created by LJ on 2018/8/10.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigleTimeSelectView : UIView

@property (nonatomic, strong) NSString *timeStr, *maxTime, *minTime;

- (void)dismissTimeSelector;

@end
