//
//  JTDatePicker.m
//  JingTeYuHui
//
//  Created by LJ on 2018/7/26.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "JTDatePicker.h"
#import "PCHeader.h"
@interface JTDatePicker ()

@property (nonatomic, strong) UIDatePicker *picker;

@property (nonatomic, strong) UIView *bgV;

@end

@implementation JTDatePicker

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.timeChangeSubject = [RACSubject subject];
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Width/2)];
        self.picker.backgroundColor = HexColor(@"f2f2f2");
        self.picker.date = [NSDate date];
        self.picker.datePickerMode = UIDatePickerModeDate;
        self.picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [self.picker addTarget:self action:@selector(picker:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.picker];
        
        self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.bgV.backgroundColor = [UIColor clearColor];
        self.bgV.alpha = 0.01;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.bgV addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self animation];
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    if (timeStr.length) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        if (timeStr.length >10) {
            [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        } else {
            [format setDateFormat:@"yyyy-MM-dd"];
        }
        self.picker.date = [format dateFromString:timeStr];
    }
}

- (void)setPickerModel:(UIDatePickerMode)pickerModel {
    _pickerModel = pickerModel;
    self.picker.datePickerMode = pickerModel;
}

- (void)setMaxTimeStr:(NSString *)maxTimeStr {
    _maxTimeStr = maxTimeStr;
    if (maxTimeStr.length) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        if (maxTimeStr.length >10) {
            [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        } else {
            [format setDateFormat:@"yyyy-MM-dd"];
        }
        self.picker.maximumDate = [format dateFromString:maxTimeStr];
    } else {
        self.picker.maximumDate = [NSDate date];
    }
    
}

- (void)setMinTimeStr:(NSString *)minTimeStr {
    _minTimeStr = minTimeStr;
    if (minTimeStr.length) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        if (minTimeStr.length >10) {
            [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        } else {
            [format setDateFormat:@"yyyy-MM-dd"];
        }
        self.picker.minimumDate = [format dateFromString:minTimeStr];
    } else {
        self.picker.minimumDate = [NSDate date];
    }
    
}

- (void)animation {
    CGRect frame = self.picker.frame;
    if (!self.hasShow) {
        if (self.isFull) {
            self.bgV.frame = [UIScreen mainScreen].bounds;
            self.bgV.backgroundColor = [HEX_333 colorWithAlphaComponent:0.4];
        }
        frame.origin.y = Screen_Height-Screen_Width/2;
        [APPWINDOW addSubview:self.bgV];
        [APPWINDOW addSubview:self.picker];
        [UIView animateWithDuration:0.3 animations:^{
            self.bgV.alpha = 1;
            self.picker.frame = frame;
        }];
        self.hasShow = YES;
    } else {
        frame.origin.y = Screen_Height;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgV.alpha = 0.01;
            self.picker.frame = frame;
            self.hasShow = NO;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.bgV removeFromSuperview];
        }];
    }
}

- (void)picker:(UIDatePicker *)picker {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    if (_pickerModel) {
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [format setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *dateStr = [format stringFromDate:picker.date];
    self.timeStr = dateStr;
    [self.timeChangeSubject sendNext:self.timeStr];
}


@end
