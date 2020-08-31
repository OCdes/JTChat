//
//  UIButton+Setting.h
//  JingTeYuHui
//
//  Created by LJ on 2018/6/28.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Setting)

@property (nonatomic, strong) NSString *title, *titleSelected, *image, *imageSelected;
@property (nonatomic, strong) UIColor *titleColor, *titleSelectedColor;
@property (strong, nonatomic) UIColor *highlightedTitleColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;
@property (copy, nonatomic) NSString *highlightedTitle;
@property (copy, nonatomic) NSString *selectedTitle;

@property (copy, nonatomic) NSString *highlightedImage;
@property (copy, nonatomic) NSString *selectedImage;

@property (copy, nonatomic) NSString *bgImage;
@property (copy, nonatomic) NSString *highlightedBgImage;
@property (copy, nonatomic) NSString *selectedBgImage;

- (void)addTarget:(id)target action:(SEL)action;

@end
