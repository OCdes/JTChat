//
//  QRView.m
//  JingTeYuHui
//
//  Created by LJ on 2018/7/18.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "QRView.h"
#import "PCHeader.h"
@interface QRView () <UIActionSheetDelegate> {
    CGRect _frame;
    CGFloat _scale;
}

@property (nonatomic, strong) UIView *qrV, *bgV;

@property (nonatomic, strong) UIImageView *logoV, *qrImgV;

@property (nonatomic, strong) UILabel *branchName, *nameLa, *phoneLa;

@property (nonatomic, strong) UIButton *closeBtn, *moreBtn;


@end

@implementation QRView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.userInteractionEnabled = YES;
        NSDictionary *dict = [USERDEFAULTS objectForKey:@"userInnfoData"];
        self.closeBtn = [UIButton new];
        self.closeBtn.image = @"jiantou";
        [self.closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            CGFloat top = 34;
            if (IphoneX) {
                top = 54;
            }
            make.top.equalTo(self).offset(top);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.moreBtn = [UIButton new];
        self.moreBtn.image = @"more";
        [self.moreBtn addTarget:self action:@selector(moreBtnClicked:)];
        [self addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-21);
            CGFloat top = 34;
            if (IphoneX) {
                top = 54;
            }
            make.top.equalTo(self).offset(top);
            make.size.mas_equalTo(CGSizeMake(70, 40));
        }];
        _scale = 0.2;
        if (IphoneX) {
            _scale = 0.38;
        }
        _frame = CGRectMake(Screen_Width*0.055, Screen_Width*_scale, Screen_Width*0.89, (Screen_Height-Screen_Width*2*_scale));
        self.qrV = [[UIView alloc] initWithFrame:CGRectMake(Screen_Width*0.055, Screen_Height, Screen_Width*0.89, (Screen_Height-Screen_Width*2*_scale))];
        self.qrV.backgroundColor = [UIColor whiteColor];
        self.qrV.layer.cornerRadius = 2.5;
        self.qrV.layer.shadowColor = [HEX_333 colorWithAlphaComponent:0.5].CGColor;
        self.qrV.layer.shadowOffset = CGSizeZero;
        self.qrV.layer.shadowOpacity = 1.0;
        [self.qrV addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
        UIImageView *imgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card"]];
        imgBg.layer.cornerRadius = 2.5;
        imgBg.layer.masksToBounds = YES;
        [self.qrV addSubview:imgBg];
        [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.qrV);
            make.height.equalTo(imgBg.mas_width).multipliedBy(0.61);
        }];
        self.branchName = [UILabel new];
        self.branchName.textColor = HEX_999;
        NSDictionary *placeInfo = [USERDEFAULTS objectForKey:@"placeInfo"];
        self.branchName.text = placeInfo[@"placeName"];
        self.branchName.font = SYS_FONT(14);
        [imgBg addSubview:self.branchName];
        [self.branchName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(imgBg).offset(20);
        }];

        self.logoV = [[UIImageView alloc] init];
        self.logoV.layer.cornerRadius = 1.5;
        self.logoV.layer.masksToBounds = YES;
        [imgBg addSubview:self.logoV];
        [self.logoV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgBg).offset(20);
            make.right.equalTo(imgBg).offset(-20);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];

        self.nameLa = [UILabel new];
        self.nameLa.font = SYS_FONT(25);
        self.nameLa.textColor = HEX_333;
        self.nameLa.text = dict[@"emp_name"];
        [imgBg addSubview:self.nameLa];
        [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.branchName);
            make.top.equalTo(self.branchName.mas_bottom).offset(30);
            make.width.mas_lessThanOrEqualTo(150);
        }];

        self.phoneLa = [UILabel new];
        self.phoneLa.textColor = HEX_999;
        self.phoneLa.font = SYS_FONT(12);
        self.phoneLa.text = dict[@"emp_phone"];
        [imgBg addSubview:self.phoneLa];
        [self.phoneLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLa);
            make.bottom.equalTo(imgBg).offset(-30);
        }];
        
        NSString *codeStr = dict[@"empQRCode"];
        self.qrImgV = [[UIImageView alloc] initWithImage:[[ALGeneratorQRCode shareInstance] generateQRCode:codeStr.length?codeStr:@""]];
        [self.qrV addSubview:self.qrImgV];
        [self.qrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.qrV).offset(-(Screen_Width*0.2));
            make.left.equalTo(self.qrV).offset(Screen_Width*0.2);
            make.size.mas_equalTo(CGSizeMake(Screen_Width*0.48, Screen_Width*0.48));
        }];
        [self addSubview:self.qrV];
        
        UILabel *notiLa = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_frame)+30, Screen_Width, 30)];
        notiLa.textAlignment = NSTextAlignmentCenter;
        notiLa.textColor = HEX_666;
        notiLa.font = SYS_FONT(12);
        notiLa.text = @"扫描上面的二维码,加我为好友";
        [self.bgV addSubview:notiLa];
    }
    return self;
}

- (void)refresh {
    NSDictionary *dict = [USERDEFAULTS objectForKey:@"userInnfoData"];
    NSDictionary *placeInfo = [USERDEFAULTS objectForKey:@"placeInfo"];
    self.branchName.text = placeInfo[@"placeName"];
    self.nameLa.text = dict[@"emp_name"];
    self.phoneLa.text = dict[@"emp_phone"];
    if ([dict[@""] length]) {
        self.logoV.image = [UIImage imageNamed:dict[@""]];
    } else {
        [self.logoV sd_setImageWithURL:[NSURL URLWithString:dict[@"emp_avatar"]] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    }
}

- (void)show {
    [self refresh];
    CGRect frame = self.qrV.frame;
    frame.origin.y = Screen_Width*_scale;
    [APPWINDOW addSubview:self.bgV];
    [APPWINDOW addSubview:self];
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.bgV.alpha = 1;
        self.qrV.frame = frame;
        self.closeBtn.alpha = 1;
        self.moreBtn.alpha = 1;
    }];
}

- (void)hide {
    CGRect frame = self.qrV.frame;
    frame.origin.y = Screen_Height;
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.bgV.alpha = 0.01;
        self.qrV.frame = frame;
        self.closeBtn.alpha = 0.01;
        self.moreBtn.alpha = 0.01;
    } completion:^(BOOL finished) {
        @strongify(self);
        [self removeFromSuperview];
        [self.bgV removeFromSuperview];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    CGRect frame = self.qrV.frame;
    CGPoint p = [sender translationInView:self];
    CGFloat hideY = Screen_Width*0.5;
    CGFloat process = 1.;
    if (sender.state == UIGestureRecognizerStateChanged) {
        frame.origin.y = _frame.origin.y+p.y;
        if (p.y/hideY > 0.3) {
            process -= (p.y/hideY);
        } else if (p.y/hideY > 1) {
            process = 0.3;
        } else {
            process = 1.;
        }
        @weakify(self);
        [UIView animateWithDuration:0.3 animations:^{
            @strongify(self);
            self.bgV.alpha = process;
            self.qrV.frame = frame;
            self.closeBtn.alpha = process;
            self.moreBtn.alpha = process;
        }];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (p.y < 0) {
            frame = _frame;
            process = 1;
            @weakify(self);
            [UIView animateWithDuration:0.3 animations:^{
                @strongify(self);
                self.bgV.alpha = process;
                self.qrV.frame = frame;
                self.closeBtn.alpha = process;
                self.moreBtn.alpha = process;
            }];
        } else if (p.y > hideY) {
            frame.origin.y = Screen_Height;
            process = 0.01;
            @weakify(self);
            [UIView animateWithDuration:0.3 animations:^{
                @strongify(self);
                self.bgV.alpha = process;
                self.qrV.frame = frame;
                self.closeBtn.alpha = process;
                self.moreBtn.alpha = process;
            } completion:^(BOOL finished) {
                @strongify(self);
                [self removeFromSuperview];
                [self.bgV removeFromSuperview];
            }];
        } else {
            frame.origin.y = Screen_Width*_scale;
            process = 1;
            @weakify(self);
            [UIView animateWithDuration:0.3 animations:^{
                @strongify(self);
                self.bgV.alpha = process;
                self.qrV.frame = frame;
                self.closeBtn.alpha = process;
                self.moreBtn.alpha = process;
            }];
        }
    }
}

- (void)moreBtnClicked:(UIButton *)sender {
//    UIAlertController *vc = [[UIAlertController alloc] init];
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [vc addAction:cancle];
//    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [vc addAction:save];
//    UIAlertAction *refresh = [UIAlertAction actionWithTitle:@"重置二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [vc addAction:refresh];
//
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", @"重置二维码", nil];
    [sheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSDictionary *dict = [USERDEFAULTS objectForKey:@"userInnfoData"];
    switch (buttonIndex) {
        case 0:
            {
                SHOWHUD(@"保存中");
                [self loadImageFinished:[self openglSnapshotImage]];
            }
            break;
        case 1:
        {
            self.qrImgV.image = [[ALGeneratorQRCode shareInstance] generateQRCode:[NSString stringWithFormat:@"addFriend:%@_%@",dict[@"emp_phone"], dict[@"PlaceID"]]];
            SHOW_SUCCESS(@"刷新成功")
        }
            break;
        default:
            break;
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        SHOW_SUCCESS(@"保存成功");
    } else {
        SHOW_ERROE(@"保存失败");
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark - lazyload

- (UIView *)bgV {
    if (!_bgV) {
        _bgV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgV.backgroundColor = [UIColor whiteColor];
        _bgV.alpha = 0.2;
    }
    return _bgV;
}

@end
