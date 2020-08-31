//
//  GeneralScrollCateView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/10/9.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralScrollCateView : UIView

@property (nonatomic, strong) RACSubject *sureSubject;

@property (nonatomic, strong) NSString *dataStr;

@property (nonatomic, strong) NSArray *dataArr;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
