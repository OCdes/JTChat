//
//  DiscountScrollView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "DiscountScrollView.h"
#import "GeneralTimeManager.h"
#import "GeneralPickerView.h"
#import "PCHeader.h"
@interface DiscountScrollView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) GeneralPickerView *pickerView, *pickerView2;

@property (nonatomic, strong) UIButton *closeBtn, *cancleBtn, *sureBtn;

@property (nonatomic, strong) UILabel *startTimeLa, *titleLa1;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *firstrArr, *secondArr, *sSecondArr;

@property (nonatomic, strong) NSString *firstStr, *secondStr;

@end

@implementation DiscountScrollView

- (instancetype)initWithFrame:(CGRect)frame {
//    frame.origin.y = Screen_Height;
    if (self = [super initWithFrame:frame]) {
        self.firstrArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        self.sSecondArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        self.secondArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        self.firstStr = self.firstrArr[0];
        self.secondStr = self.secondArr[0];
        self.startTimeLa.text = NSStringFormate(@"%@.%@  折",self.firstStr, self.secondStr);
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
        titleLa.text = @"选择折扣为";
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
        
        UIView * grayView = [UIView new];
        grayView.backgroundColor = HexColor(@"#F9F8F9");
        [self addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(122, 20, 116, 20));
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.startTimeLa.mas_bottom).offset(33);
            make.width.mas_equalTo((self.frame.size.width-50)/2.);
            make.bottom.equalTo(self).offset(-116);
        }];
        
        UILabel *la = [UILabel new];
        la.textColor = HEX_333;
        la.backgroundColor = HEX_FFF;
        la.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",la.font.fontName) size:14];
        la.text = @".";
        la.textAlignment = NSTextAlignmentCenter;
        [self addSubview:la];
        [la mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pickerView.mas_right);
            make.centerY.equalTo(self.pickerView);
            make.size.mas_equalTo(CGSizeMake(10, 52));
        }];
        
        [self addSubview:self.pickerView2];
        [self.pickerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.bottom.top.equalTo(self.pickerView);
            make.left.equalTo(self.pickerView.mas_right).offset(5);
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

#pragma mark - UIPickerViewDelegate&DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        return self.firstrArr.count;
    } else {
        if (![self.firstStr isEqualToString:@"0"]) {
            return self.sSecondArr.count;
        } else {
            return self.secondArr.count;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.frame.size.width- 50)/2.;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 52;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *reView = (UILabel *)view;
    if (!reView) {
        reView = [[UILabel alloc] init];
        reView.textColor = HEX_333;
        reView.font = SYS_FONT(16);
    }
    if (pickerView.tag == 0) {
        reView.textAlignment = NSTextAlignmentRight;
        reView.text = self.firstrArr[row];
    } else {
        reView.textAlignment = NSTextAlignmentLeft;
        if (![self.firstStr isEqualToString:@"0"]) {
            reView.text = NSStringFormate(@"  %@  折",self.sSecondArr[row]);
        } else {
            reView.text = NSStringFormate(@"  %@  折",self.secondArr[row]);
        }
    }
    return reView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 0) {
        self.firstStr = self.firstrArr[row];
        [self.pickerView2 reloadAllComponents];
        [self.pickerView2 selectRow:0 inComponent:0 animated:YES];
        [self pickerView:self.pickerView2 didSelectRow:0 inComponent:0];
    } else {
        if (![self.firstStr isEqualToString:@"0"]) {
            self.secondStr = self.sSecondArr[row];
        } else {
            self.secondStr = self.secondArr[row];
        }
    }
    self.startTimeLa.text = NSStringFormate(@"%@.%@  折",self.firstStr, self.secondStr);
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
    self.discountStr = NSStringFormate(@"%@.%@",self.firstStr, self.secondStr);
    [self.sureSubject sendNext:self.discountStr];
    [self hide];
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

- (GeneralPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[GeneralPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = HexColor(@"#F9F8F9");
        _pickerView.tag = 0;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (GeneralPickerView *)pickerView2 {
    if (!_pickerView2) {
        _pickerView2 = [[GeneralPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView2.dataSource = self;
        _pickerView2.delegate = self;
        _pickerView2.backgroundColor = HexColor(@"#F9F8F9");
        _pickerView2.tag = 1;
        _pickerView2.showsSelectionIndicator = YES;
    }
    return _pickerView2;
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
