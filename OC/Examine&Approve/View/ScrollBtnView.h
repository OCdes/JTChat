//
//  ScrollBtnView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/20.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface ScrollBtnView : UIView

@property (nonatomic, strong) RACSubject *tapSubject;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

- (instancetype)initOrderListWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

- (void)relodaData:(NSArray *)titleArr;

@end

NS_ASSUME_NONNULL_END
