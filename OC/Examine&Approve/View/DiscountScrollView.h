//
//  DiscountScrollView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface DiscountScrollView : UIView

@property (nonatomic, strong) RACSubject *sureSubject;

@property (nonatomic, strong) NSString *discountStr;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
