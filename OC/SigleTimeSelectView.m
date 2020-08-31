//
//  SigleTimeSelectView.m
//  JingTeYuHui
//
//  Created by LJ on 2018/8/10.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "SigleTimeSelectView.h"
#import "JTDatePicker.h"
#import "PCHeader.h"
#import "ETFTool.h"
@interface SigleTimeSelectView ()

@property (nonatomic, strong) UILabel *timeLa;

@property (nonatomic, strong) JTDatePicker *picker;

@end

@implementation SigleTimeSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.timeLa];
        [self.timeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-25);
        }];
        
        RAC(self.timeLa, text) = RACObserve(self, timeStr);
        RAC(self.picker, timeStr) = RACObserve(self.timeLa, text);
        @weakify(self);
        [self.picker.timeChangeSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSString *timeStr = (NSString *)x;
            self.timeStr = timeStr;
        }];
    }
    return self;
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
}

- (void)setMaxTime:(NSString *)maxTime {
    _maxTime = maxTime;
    self.picker.maxTimeStr = maxTime;
}

- (void)setMinTime:(NSString *)minTime {
    _minTime = minTime;
    self.picker.minTimeStr = minTime;
}

- (void)tap1:(UITapGestureRecognizer *)sender {
    [self.picker animation];
}

- (void)dismissTimeSelector {
    if (self.picker.hasShow) {
        [self.picker animation];
    }
}

#pragma mark - Lazyload

- (UILabel *)timeLa {
    if (!_timeLa) {
        _timeLa = [UILabel new];
        _timeLa.font = SYS_FONT(14);
        _timeLa.textColor = HEX_333;
        _timeLa.textAlignment = NSTextAlignmentCenter;
        _timeLa.userInteractionEnabled = YES;
        _timeLa.layer.cornerRadius = 5;
        _timeLa.layer.masksToBounds = YES;
        _timeLa.layer.borderColor = HEX_333.CGColor;
        _timeLa.layer.borderWidth = 0.5;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
        [_timeLa addGestureRecognizer:tap1];
    }
    return _timeLa;
}

- (JTDatePicker *)picker {
    if (!_picker) {
        _picker = [[JTDatePicker alloc] init];
        _picker.maxTimeStr = [[ETFTool new] today];
    }
    return _picker;
}

@end
