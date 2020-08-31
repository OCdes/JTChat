//
//  UIColor+HexColor.h
//  Swift-jtyh
//
//  Created by LJ on 2020/3/25.
//  Copyright © 2020 WanCai. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColor)

+ (UIColor *) colorFromHexCode:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
