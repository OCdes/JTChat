//
//  ImageSketcherTool.h
//  Swift-jtyh
//
//  Created by LJ on 2020/6/11.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageSketcherTool : UIView

+ (instancetype)shareTool;

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor*)textColor font:(UIFont *)font backgrouColor:(UIColor*)backColor size:(CGSize )size;

- (UIImage *)leftTrangleSideLength:(CGFloat)length;

- (UIImage *)flurImageSize:(CGSize )size;

@end

NS_ASSUME_NONNULL_END
