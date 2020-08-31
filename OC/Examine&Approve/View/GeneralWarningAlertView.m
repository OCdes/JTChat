//
//  GeneralWarningAlertView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/21.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralWarningAlertView.h"
#import "PCHeader.h"
@interface GeneralWarningAlertView ()

@property (nonatomic, strong) UILabel *titleLa, *contentLa;

@property (nonatomic, strong) UIButton *cancleBtn, *sureBtn;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation GeneralWarningAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cancleSubject = [RACSubject subject];
        self.sureSubject = [RACSubject subject];
        self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.bgView.userInteractionEnabled = YES;
        self.bgView.backgroundColor = [HEX_333 colorWithAlphaComponent:0.3];
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        self.bgView.alpha = 0.01;
        self.center = self.bgView.center;
        self.backgroundColor = HEX_FFF;
        self.titleLa = [UILabel new];
        self.titleLa.font = SYS_FONT(16);
        self.titleLa.textColor = HEX_333;
        self.titleLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(15);
            make.height.mas_lessThanOrEqualTo(16);
        }];
        
        self.cancleBtn = [UIButton new];
        self.cancleBtn.titleColor = HexColor(@"#2E96F7");
        self.cancleBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.cancleBtn.titleLabel.font.fontName) size:18];
        self.cancleBtn.title = @"取消";
        [self.cancleBtn addTarget:self action:@selector(cancleBtnClicked:)];
        LineView *line = [[LineView alloc] init];
        [self.cancleBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.cancleBtn);
            make.height.mas_equalTo(0.5);
        }];
        [self addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake((frame.size.width)/2., 44));
        }];
        
        self.sureBtn = [UIButton new];
        self.sureBtn.titleColor = HEX_FFF;
        self.sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.cancleBtn.titleLabel.font.fontName) size:18];
        self.sureBtn.backgroundColor = HexColor(@"#2E96F7");
        self.sureBtn.title = @"确定";
        [self.sureBtn addTarget:self action:@selector(sureBtnClicked:)];
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.size.equalTo(self.cancleBtn);
        }];
        
        self.contentLa = [UILabel new];
        self.contentLa.textColor = HEX_666;
        self.contentLa.font = SYS_FONT(16);
        self.contentLa.textAlignment = NSTextAlignmentCenter;
        self.contentLa.numberOfLines = 0;
        [self addSubview:self.contentLa];
        [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.titleLa.mas_bottom);
            make.bottom.equalTo(self.cancleBtn.mas_top);
        }];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    return self;
}

- (void)animation {
    [APPWINDOW addSubview:self.bgView];
    [APPWINDOW addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.bgView.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.01;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

- (void)cancleBtnClicked:(UIButton *)btn {
    [self.cancleSubject sendNext:nil];
    [self hide];
}

- (void)sureBtnClicked:(UIButton *)btn {
    [self.sureSubject sendNext:nil];
    [self hide];
}

- (void)setTitleStr:(NSMutableAttributedString *)titleStr {
    _titleStr = titleStr;
    self.titleLa.attributedText = titleStr;
}

- (void)setContentStr:(NSMutableAttributedString *)contentStr {
    _contentStr = contentStr;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [contentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    self.contentLa.attributedText = contentStr;
}

- (void)setCancleStr:(NSString *)cancleStr {
    _cancleStr = cancleStr;
    self.cancleBtn.title = cancleStr;
}

- (void)setSureStr:(NSString *)sureStr {
    _sureStr = sureStr;
    self.sureBtn.title = sureStr;
}

@end
