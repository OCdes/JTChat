//
//  InfiniteTimeView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/26.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface InfiniteTimeView : UIView

@property (nonatomic, strong) RACSubject *sureSubject;

@property (nonatomic, strong) NSString *dateStr;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
