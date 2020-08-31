//
//  DropdownMenu.h
//  JingTeYuHui
//
//  Created by LJ on 2018/7/2.
//  Copyright © 2018年 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownMenu : UIView

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor, *selectColor;
@property (nonatomic, strong) UIColor *menuBackgroudColor;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *seleKey;
@property (nonatomic, assign) NSTextAlignment textAligment;
@property (nonatomic, copy) void(^didSelectCallback)(NSInteger index, NSString *content);

@end

@interface StoreDropdownMenu : UIView

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor, *selectColor;
@property (nonatomic, strong) UIColor *menuBackgroudColor;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSString *seleKey;
@property (nonatomic, assign) NSTextAlignment textAligment;
@property (nonatomic, copy) void(^didSelectCallback)(NSInteger index, NSDictionary *content);

@end
