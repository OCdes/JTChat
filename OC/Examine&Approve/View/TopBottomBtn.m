//
//  TopBottomBtn.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "TopBottomBtn.h"
#import "PCHeader.h"
@interface TopBottomBtn ()

@property (nonatomic, strong) UILabel *numLa;

@end

@implementation TopBottomBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numLa = [UILabel new];
        self.numLa.textColor = HEX_FFF;
        self.numLa.textAlignment = NSTextAlignmentCenter;
        self.numLa.backgroundColor = HexColor(@"#FD3D31");
        self.numLa.font = SYS_FONT(10);
        self.numLa.layer.cornerRadius = 6.5;
        self.numLa.layer.masksToBounds = YES;
        self.numLa.hidden = YES;
        [self addSubview:self.numLa];
        [self.numLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(13);
            make.centerY.equalTo(self).offset(-25);
            make.height.mas_equalTo(13);
            make.width.mas_greaterThanOrEqualTo(13);
        }];
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    self.numLa.hidden = !num;
    if (num>99) {
        self.numLa.text = NSStringFormate(@"99+");
    } else {
        self.numLa.text = NSStringFormate(@"%li",num);
    }
}



-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.width = self.frame.size.width;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(midX, midY + 15);
    self.imageView.center = CGPointMake(midX, midY - 15);
}

@end
