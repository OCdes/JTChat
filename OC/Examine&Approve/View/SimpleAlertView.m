//
//  SimpleAlertView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/10/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "SimpleAlertView.h"
#import "PCHeader.h"
@interface SimpleAlertView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *contentLa;

@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation SimpleAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.sureSubject = [RACSubject subject];
        CGRect frame = CGRectMake(0, 0, 232, 160);
        self.frame = frame;
        self.center = APPWINDOW.center;
        self.backgroundColor = HEX_FFF;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        self.bgView.backgroundColor = [HEX_333 colorWithAlphaComponent:0.7];
        
        self.contentLa = [UILabel new];
        self.contentLa.textColor = HEX_333;
        self.contentLa.font = SYS_FONT(16);
        self.contentLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLa];
        [self.contentLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(35, 15, 98, 15));
        }];
        
        self.sureBtn = [UIButton new];
        self.sureBtn.titleColor = HEX_FFF;
        self.sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",self.sureBtn.titleLabel.font.fontName) size:18];
        self.sureBtn.backgroundColor = HexColor(@"#2E96F7");
        self.sureBtn.layer.cornerRadius = 5;
        self.sureBtn.layer.masksToBounds = YES;
        [self.sureBtn addTarget:self action:@selector(hide)];
        [self addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-27);
            make.size.mas_equalTo(CGSizeMake(140, 44));
        }];
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    return self;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    CGFloat width = 202;
    CGFloat height = [contentStr heightWithFont:SYS_FONT(16) constrainedToWidth:width];
    if (height > 27) {
        CGFloat nHeight = self.frame.size.height+height-16;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, nHeight);
    }
    self.contentLa.text = contentStr;
}

- (void)setSureTitle:(NSString *)sureTitle {
    _sureTitle = sureTitle;
    self.sureBtn.title = sureTitle;
}

- (void)show {
    [APPWINDOW addSubview:self.bgView];
    [APPWINDOW addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }];
}

@end
