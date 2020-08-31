//
//  RestoreAlert.m
//  JingTeYuHui
//
//  Created by LJ on 2019/3/14.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "RestoreAlert.h"
#import "PCHeader.h"
@interface RestoreAlert ()

@property (nonatomic, strong) UIView *maskView;

@end

@implementation RestoreAlert

- (instancetype)init {
    if (self = [super init]) {
        self.sureSubject = [RACSubject subject];
        self.cancelSubject = [RACSubject subject];
        self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.maskView.backgroundColor = [HEX_333 colorWithAlphaComponent:0.4];
        self.frame = CGRectMake(0, 0, 306, 335);
        self.backgroundColor = HEX_FFF;
        self.center = self.maskView.center;
        self.userInteractionEnabled = YES;
        self.maskView.alpha = 0.01;
        UIImageView *imgV = [UIImageView new];
        imgV.image = [UIImage imageNamed:@"restore"];
        imgV.userInteractionEnabled = YES;
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        UILabel *label = [UILabel new];
        label.font = SYS_FONT(15);
        label.textColor = HEX_666;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您上次离开没有保存编辑资料\n系统已为您自动保存上次编辑数据";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(200);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *label2 = [UILabel new];
        label2.font = SYS_FONT(15);
        label2.textColor = HexColor(@"#229AFB");
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"是否恢复";
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom);
            make.right.left.equalTo(label);
            make.height.mas_equalTo(15);
        }];
        
        UIButton *sureBtn = [UIButton new];
        sureBtn.title = @"确定";
        sureBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",sureBtn.titleLabel.font.fontName) size:18];
        [sureBtn addTarget:self action:@selector(sureBtnClicked:)];
        sureBtn.titleColor = HEX_FFF;
        sureBtn.backgroundColor = HexColor(@"#2E96F7");
        [self addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(153, 44));
        }];
        
        UIButton *cancleBtn = [UIButton new];
        cancleBtn.title = @"取消";
        cancleBtn.titleLabel.font = [UIFont fontWithName:NSStringFormate(@"%@-Medium",cancleBtn.titleLabel.font.fontName) size:18];
        [cancleBtn addTarget:self action:@selector(cancleBtnClicked:)];
        cancleBtn.titleColor = HexColor(@"#2E96F7");
        cancleBtn.backgroundColor = HEX_FFF;
        [self addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.size.equalTo(sureBtn);
        }];
        
        LineView *line = [[LineView alloc] init];
        [cancleBtn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(cancleBtn);
            make.height.mas_equalTo(1);
        }];
        
        self.layer.cornerRadius = 5;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    return self;
}

- (void)sureBtnClicked:(UIButton *)btn {
    [self.sureSubject sendNext:nil];
    if (_SureBlock) {
        _SureBlock();
    }
    [self hide];
}

- (void)cancleBtnClicked:(UIButton *)btn {
    [self.cancelSubject sendNext:nil];
    if (_CancleBlock) {
        _CancleBlock();
    }
    [self hide];
}

- (void)animation {
    [APPWINDOW addSubview:self.maskView];
    [APPWINDOW addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1.;
        self.transform = CGAffineTransformMakeScale(1., 1.);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.maskView.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

@end
