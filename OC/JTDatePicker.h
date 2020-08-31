//
//  JTDatePicker.h
//  JingTeYuHui
//
//  Created by LJ on 2018/7/26.
//  Copyright © 2018年 WanCai. All rights reserved.//

#import <UIKit/UIKit.h>
@class RACSubject;
@interface JTDatePicker : UIView

@property (nonatomic, strong) NSString *timeStr, *maxTimeStr, *minTimeStr;

@property (nonatomic, strong) RACSubject *timeChangeSubject;

@property (nonatomic, assign) UIDatePickerMode pickerModel;

@property (nonatomic, assign) BOOL isFull;

@property (nonatomic, assign) BOOL hasShow;

- (void)animation;

@end
