//
//  GeneralScrollCateView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/10/9.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralScrollCateView.h"
#import "GeneralTimeManager.h"
#import "GeneralPickerView.h"
#import "PCHeader.h"
@interface GeneralScrollCateView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *cancleBtn, *sureBtn;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSString *firstStr;

@end

@implementation GeneralScrollCateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        frame.size.height = Screen_Width*0.9;
        self.frame = frame;
        self.sureSubject = [RACSubject subject];
        self.backgroundColor = HexColor(@"#F9F8F9");
        
        CGFloat width = 80;
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, 40));
        }];
        
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.size.top.equalTo(self.cancleBtn);
        }];
        
        LineView *line = [[LineView alloc] init];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.sureBtn.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line.mas_bottom).offset(33);
            make.bottom.equalTo(self).offset(-44);
        }];
        
        self.frame = CGRectMake(0, Screen_Height, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.dataStr = [dataArr firstObject];
    [self.pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate&DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.frame.size.width- 50);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *reView = (UILabel *)view;
    if (!reView) {
        reView = [[UILabel alloc] init];
        reView.textColor = HEX_333;
        reView.font = SYS_FONT(16);
        reView.textAlignment = NSTextAlignmentCenter;
    }
    reView.text = self.dataArr[row];
    return reView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.dataStr = self.dataArr[row];
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
    [self.sureSubject sendNext:self.dataStr];
    [self hide];
}

- (void)show {
    if (self.dataArr.count) {
        [APPWINDOW addSubview:self.bgView];
        [APPWINDOW addSubview:self];
        CGRect frame = CGRectMake(0, Screen_Height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }
    
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

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = HexColor(@"#F9F8F9");
        _pickerView.tag = 0;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        _cancleBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_cancleBtn.titleLabel.font.fontName) size:18];
        _cancleBtn.titleColor = HEX_666;
        _cancleBtn.title = @"取消";
        [_cancleBtn addTarget:self action:@selector(hide)];
    }
    return _cancleBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        _sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",_sureBtn.titleLabel.font.fontName) size:18];
        _sureBtn.titleColor = HexColor(@"#1D83F4");
        _sureBtn.title = @"确定";
        [_sureBtn addTarget:self action:@selector(sureBtnClicked:)];
    }
    return _sureBtn;
}

@end
