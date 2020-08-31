//
//  InfiniteTimeView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/26.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "InfiniteTimeView.h"
#import "PCHeader.h"
@interface InfiniteTimeView ()

@property (nonatomic, strong) UIDatePicker *pickerView;

@property (nonatomic, strong) UIButton *closeBtn, *cancleBtn, *sureBtn;

@property (nonatomic, strong) UILabel *startTimeLa, *titleLa1;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation InfiniteTimeView

- (instancetype)initWithFrame:(CGRect)frame {
//    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.sureSubject = [RACSubject subject];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [UIView new];
        contentView.backgroundColor = HEX_FFF;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.bounds = contentView.bounds;
        contentView.layer.mask = layer;
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        
        UILabel *titleLa = [UILabel new];
        titleLa.textColor = HexColor(@"#2E96F7");
        titleLa.font = SYS_FONT(13);
        titleLa.text = @"选择日期为";
        [self addSubview:titleLa];
        [titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.top.equalTo(self).offset(50);
            make.size.mas_equalTo(CGSizeMake(80, 13));
        }];
        
        [self addSubview:self.startTimeLa];
        [self.startTimeLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLa.mas_left);
            make.top.equalTo(titleLa.mas_bottom).offset(13);
            make.right.equalTo(self).offset(-20);
            make.height.mas_equalTo(13);
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        LineView *line = [[LineView alloc] init];
        line.backgroundColor = HexColor(@"#2E96F7");
        line.layer.cornerRadius = 2;
        line.layer.masksToBounds = YES;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(4, 20));
        }];
        
        CGFloat width = (self.frame.size.width-40)/2.;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.pickerView.mas_bottom).offset(40);
            make.size.mas_equalTo(CGSizeMake(width, 44));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancleBtn.mas_right);
            make.size.top.equalTo(self.cancleBtn);
        }];
        
    }
    return self;
}

- (void)pickerViewScrolled:(UIDatePicker *)sender {
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy.MM.dd hh:mm"];
    [formmater setTimeZone:[NSTimeZone localTimeZone]];
    self.startTimeLa.text = [formmater stringFromDate:sender.date];
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

#pragma mark - ClickingEvents

- (void)sureBtnClicked:(UIButton *)btn {
    if ([self anySubviewScrolling:self.pickerView]) return;
    [self.sureSubject sendNext:self.startTimeLa.text];
}

- (void)show {
    [APPWINDOW addSubview:self.bgView];
    [APPWINDOW addSubview:self];
    CGRect frame = CGRectMake(0, Screen_Height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    }];
}

- (void)hide {
    CGRect frame = CGRectMake(0, Screen_Height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;

    
}

#pragma mark - LazyLoad

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [HEX_333 colorWithAlphaComponent:0.7];
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    }
    return _bgView;
}

- (UILabel *)startTimeLa {
    if (!_startTimeLa) {
        _startTimeLa = [UILabel new];
        _startTimeLa.font = SYS_FONT(13);
        _startTimeLa.textColor = HEX_333;
        _startTimeLa.numberOfLines = 2;
    }
    return _startTimeLa;
}

- (UIDatePicker *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.backgroundColor = HexColor(@"#F9F8F9");
        _pickerView.datePickerMode = UIDatePickerModeDateAndTime;
        NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
        [formmater setDateFormat:@"yyyy-MM-dd"];
        [formmater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        _pickerView.minimumDate = [formmater dateFromString:@"2000-01-01"];
        _pickerView.maximumDate = [formmater dateFromString:@"3000-01-01"];
        _pickerView.minuteInterval = 30;
        [_pickerView addTarget:self action:@selector(pickerViewScrolled:) forControlEvents:UIControlEventValueChanged];
    }
    return _pickerView;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        _cancleBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_cancleBtn.titleLabel.font.fontName) size:18];
        _cancleBtn.titleColor = HexColor(@"#C0BFC4");
        _cancleBtn.title = @"取消";
        [_cancleBtn addTarget:self action:@selector(hide)];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_sureBtn.titleLabel.font.fontName) size:18];
        _sureBtn.titleColor = HEX_FFF;
        _sureBtn.title = @"确定";
        _sureBtn.backgroundColor = HexColor(@"#2E96F7");
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClicked:)];
    }
    return _sureBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.image = @"guanbi";
        [_closeBtn addTarget:self action:@selector(hide)];
    }
    return _closeBtn;
}

@end
