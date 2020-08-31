//
//  ImageSketcherTool.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/11.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "ImageSketcherTool.h"
static ImageSketcherTool *tool = nil;
@implementation ImageSketcherTool

+ (instancetype)shareTool {
    if (tool == nil) {
        static dispatch_once_t onceToken;
        if (tool == nil) {
            dispatch_once(&onceToken, ^{
                tool = [[super allocWithZone:NULL] init];
                tool.backgroundColor = UIColor.clearColor;
            });
        }
    }
    return tool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [ImageSketcherTool shareTool];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return self;
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backgrouColor:(UIColor *)backColor size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画圆角
    CGPathRef clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 0, size.width-10, size.height) cornerRadius:2].CGPath;
    CGContextAddPath(context, clipPath);
    CGContextClosePath(context);
    CGContextClip(context);
    //清除默认色
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
//    //填充颜色，绘制文本
    CGContextSetFillColorWithColor(context, backColor.CGColor);
    CGContextFillRect(context, CGRectMake(5, 0, size.width-10, size.height));
    CGContextDrawPath(context, kCGPathFill);
    NSString *str = text ? text : @"";
    NSDictionary *attr = @{NSForegroundColorAttributeName : textColor, NSFontAttributeName : font};
    NSAttributedString *mastr = [[NSAttributedString alloc] initWithString:str attributes:attr];
    CGFloat strWidth = mastr.size.width;
    CGFloat strHeight = mastr.size.height;
    [str drawInRect:CGRectMake((size.width-strWidth)/2, (size.height-strHeight)/2, strWidth, strHeight) withAttributes:attr];
    
    
    //绘制阴影
    CGContextSetShadowWithColor(context, CGSizeMake(0, 3), 1, [UIColor.lightGrayColor colorWithAlphaComponent:0.3].CGColor);
       CGContextDrawPath(context, kCGPathFill);
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return image;
}

- (UIImage *)leftTrangleSideLength:(CGFloat)length {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, length), NO, UIScreen.mainScreen.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGPoint spoint[3];
    spoint[0] = CGPointMake(length/2, length/2);
    spoint[1] = CGPointMake(length, 0);
    spoint[2] = CGPointMake(length, length);
    CGContextAddLines(context, spoint, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    return image;
}


@end
