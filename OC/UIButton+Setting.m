//
//  UIButton+Setting.m
//  JingTeYuHui
//
//  Created by LJ on 2018/6/28.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import "UIButton+Setting.h"
#import <objc/runtime.h>
#import "PCHeader.h"
@implementation UIButton (Setting)

+ (void)load {
    Method setTextMethod = class_getInstanceMethod(self, @selector(setTitle:));
    Method cosSetTextMethod = class_getInstanceMethod(self, @selector(cosSetTextMethod:));
    method_exchangeImplementations(setTextMethod, cosSetTextMethod);
    
    Method setTitleMethod = class_getInstanceMethod(self, @selector(setTitle:));
    Method rSetTitleMethod = class_getInstanceMethod(self, @selector(rSetTitle:));
    method_exchangeImplementations(setTitleMethod, rSetTitleMethod);
    
    Method getTitleMethod = class_getInstanceMethod(self, @selector(title));
    Method rGetTitleMethod = class_getInstanceMethod(self, @selector(rTitle));
    method_exchangeImplementations(getTitleMethod, rGetTitleMethod);
}

- (void)cosSetTextMethod:(NSString *)string {
    NSString *newStr;
    if (!string || [string isEqualToString:@"null"] || [string isEqualToString:@"(null)"]) {
        newStr = @"";
    }
    [self cosSetTextMethod:newStr];
}


- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)rSetTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleSelected:(NSString *)titleSelected {
    [self setTitle:titleSelected forState:UIControlStateSelected];
}

- (NSString *)titleSelected {
    return [self titleForState:UIControlStateSelected];
}

- (void)setImage:(NSString *)image {
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setImageSelected:(NSString *)imageSelected {
    [self setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
}

- (NSString *)imageSelected {
    return nil;
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}

- (UIColor *)titleSelectedColor {
    return [self titleColorForState:UIControlStateSelected];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)setHighlightedTitle:(NSString *)highlightedTitle
{
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

- (NSString *)highlightedTitle
{
    return nil;
}

- (UIColor *)titleColor
{
    return nil;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (UIColor *)highlightedTitleColor
{
    return nil;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor *)selectedTitleColor
{
    return nil;
}

- (NSString *)title
{
    return [self titleForState:UIControlStateNormal];
}

- (NSString *)rTitle {
    return [self titleForState:UIControlStateNormal];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (NSString *)selectedTitle
{
    return [self titleForState:UIControlStateSelected];
}


- (NSString *)image
{
    return nil;
}

- (void)setHighlightedImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}

- (NSString *)highlightedImage
{
    return nil;
}

- (void)setSelectedImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
}

- (NSString *)selectedImage
{
    return nil;
}

- (void)setBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (NSString *)bgImage
{
    return nil;
}

- (void)setHighlightedBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}

- (NSString *)highlightedBgImage
{
    return nil;
}

- (void)setSelectedBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
}

- (NSString *)selectedBgImage
{
    return nil;
}

@end
