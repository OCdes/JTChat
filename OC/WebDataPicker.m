
//
//  WebDataPicker.m
//  JingTeYuHui
//
//  Created by LJ on 2019/1/28.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "WebDataPicker.h"

#import "PCHeader.h"
@interface WebDataPicker ()

@property (nonatomic, strong) UIDatePicker *picker;

@property (nonatomic, strong) UIView *bgV;

@property (nonatomic, strong) UIButton *sureBtn, *cancleBtn;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation WebDataPicker

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Width/2+40)]) {
        self.backgroundColor = UIColor.whiteColor;
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, Screen_Width, Screen_Width/2)];
//        self.picker.backgroundColor = UIColor.lightGrayColor;
        self.picker.date = [NSDate date];
        self.pickerModel = UIDatePickerModeDate;
        self.picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        self.picker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        self.picker.datePickerMode = self.pickerModel;
        self.picker.date = [NSDate date];
        [self.picker addTarget:self action:@selector(picker:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.picker];
        
        self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [self.cancleBtn addTarget:self action:@selector(cancleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancleBtn];
        
        self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_Width-60, 0, 60, 40)];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sureBtn];
        self.bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.bgV.backgroundColor = [UIColor clearColor];
        self.bgV.alpha = 0.01;
        self.bgV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.bgV addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)sender {
    [self animation];
}

- (void)cancleBtnClicked:(UIButton *)btn {
    [self animation];
}

- (void)sureBtnClicked:(UIButton *)btn {
    if ([self anySubviewScrolling:self.picker]) return;
    if (!self.timeStr.length) {
        if (_pickerModel == UIDatePickerModeTime) {
            [self.formatter setDateFormat:@"HH:mm"];
        } else {
            [self.formatter setDateFormat:@"yyyy-MM-dd"];
        }
        NSString *dateStr = [self.formatter stringFromDate:self.picker.date];
        self.timeStr = dateStr;
    }
    if (_dateChangeBlock) {
        _dateChangeBlock(self.picker.date);
    }
    if (_timeChangeBlock) {
        _timeChangeBlock(self.timeStr);
    }
    [self animation];
}

- (BOOL)anySubviewScrolling:(UIView *)v {
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)v;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *vi in v.subviews) {
        if ([self anySubviewScrolling:vi]) {
            return YES;
        }
    }
    return NO;
}

- (void)setPickerModel:(UIDatePickerMode)pickerModel {
    _pickerModel = pickerModel;
    self.picker.datePickerMode = pickerModel;
}

- (void)setMaxTimeStr:(NSString *)maxTimeStr {
    _maxTimeStr = maxTimeStr;
    if (maxTimeStr.length) {
        if (_pickerModel) {
            if (maxTimeStr.length >10) {
                [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            } else {
                [self.formatter setDateFormat:@"yyyy-MM-dd"];
            }
        } else {
            [self.formatter setDateFormat:@"HH:mm"];
        }
        
        self.picker.maximumDate = [self.formatter dateFromString:maxTimeStr];
    } else {
        self.picker.maximumDate = [NSDate date];
    }
    
}

- (void)setMinTimeStr:(NSString *)minTimeStr {
    _minTimeStr = minTimeStr;
    if (minTimeStr.length) {
        if (_pickerModel) {
            if (minTimeStr.length >10) {
                [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            } else {
                [self.formatter setDateFormat:@"yyyy-MM-dd"];
            }
        } else {
            [self.formatter setDateFormat:@"HH:mm"];
        }
        
        self.picker.minimumDate = [self.formatter dateFromString:minTimeStr];
    } else {
        self.picker.minimumDate = [NSDate date];
    }
    
}

- (void)animation {
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    CGRect frame = self.frame;
    if (!self.hasShow) {
        if (self.isFull) {
            self.bgV.frame = [UIScreen mainScreen].bounds;
            self.bgV.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        }
        frame.origin.y = Screen_Height-Screen_Width/2-40;
        [window addSubview:self.bgV];
        [window addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.bgV.alpha = 1;
            self.frame = frame;
        }];
        self.hasShow = YES;
    } else {
        frame.origin.y = Screen_Height;
        [UIView animateWithDuration:0.3 animations:^{
            self.bgV.alpha = 0.01;
            self.frame = frame;
            self.hasShow = NO;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.bgV removeFromSuperview];
        }];
    }
}

- (void)picker:(UIDatePicker *)picker {
    
    if (_pickerModel) {
        [self.formatter setDateFormat:@"yyyy-MM-dd"];
    } else {
        [self.formatter setDateFormat:@"HH:mm"];
    }
    NSString *dateStr = [self.formatter stringFromDate:picker.date];
    self.timeStr = dateStr;
}

@end
