//
//  NavDropButton.h
//  JingTeYuHui
//
//  Created by LJ on 2018/10/11.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavDropButton : UIButton

@property (nonatomic, strong) NSString *contentStr;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleLa;

@end

NS_ASSUME_NONNULL_END
