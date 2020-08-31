//
//  RestoreAlert.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/14.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface RestoreAlert : UIView

@property (nonatomic, strong) RACSubject *sureSubject, *cancelSubject;
@property (nonatomic, copy) void(^SureBlock)();
@property (nonatomic, copy) void(^CancleBlock)();

- (void)animation;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
