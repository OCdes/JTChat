//
//  GeneralTimeView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/7/23.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface GeneralTimeView : UIView

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) void(^timeChangeBlock)(NSString *mixTimeStr);

- (void)dismissTimeSelector;

@end

@interface BorderBtn : UIButton

@end

NS_ASSUME_NONNULL_END
