//
//  NavDropButton.m
//  JingTeYuHui
//
//  Created by LJ on 2018/10/11.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "NavDropButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface NavDropButton ()

@end

@implementation NavDropButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.titleLabel.hidden = YES;
        self.imageView.hidden = YES;
        self.titleLa = [UILabel new];
        self.titleLa.font = [UIFont systemFontOfSize:16];
        self.titleLa.textColor = UIColor.whiteColor;
        self.titleLa.textAlignment = NSTextAlignmentRight;
        self.titleLa.userInteractionEnabled = NO;
        self.titleLa.adjustsFontSizeToFitWidth = YES;
        CGFloat width = frame.size.width-34;
        [self addSubview:self.titleLa];
        [self.titleLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(20);
            make.width.mas_lessThanOrEqualTo(width);
        }];
        self.imgV = [UIImageView new];
        self.imgV.hidden = YES;
        self.imgV.image = [[UIImage imageNamed:@"oDropDown"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.imgV.userInteractionEnabled = NO;
        self.imgV.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imgV];
        [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLa.mas_right).offset(5);
            make.centerY.equalTo(self.titleLa);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    return self;
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    [self.titleLa mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-5);
    }];
    self.titleLa.text = contentStr;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLa.font = font;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.titleLa.textColor = color;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
