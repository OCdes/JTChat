//
//  OCWaterMarkView.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/4.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "OCWaterMarkView.h"
#import "PCHeader.h"
@implementation OCWaterMarkView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    if (self = [super initWithFrame:frame]) {
        UIColor *color = [HexColor(@"#F0F0F0") colorWithAlphaComponent:0.5];
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = frame.size.height;
        
        UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
        
        CGFloat sqrtLength = sqrt(viewHeight*viewHeight+viewWidth*viewWidth);
        
        
        NSString *str = text?text:@"";
        NSDictionary *attributes = @{
        //设置字体大小
        NSFontAttributeName: font,
        //设置文字颜色
        NSForegroundColorAttributeName :color,
        };
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
        CGFloat width = attrStr.size.width;
        CGFloat heigth = attrStr.size.height;
        
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2., viewHeight/2.));
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI_4));
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2., -viewHeight/2.));
        
        int cols = sqrtLength/(width+30)+1;
        int rows = sqrtLength/(heigth+50)+1;
        
        CGFloat x = -(sqrtLength-viewWidth)/2.;
        CGFloat y = -(sqrtLength-viewHeight)/2.;
        
        for (int i = 0; i < cols*rows; i ++) {
            CGRect frame = CGRectMake(x+(width+30)*(i%cols), y+(heigth+50)*(i/cols+((i%cols > 0) ? 1 : 0)), width, heigth);
            [str drawInRect:frame withAttributes:attributes];
        }
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        CGContextRestoreGState(context);
        UIGraphicsEndImageContext();
        self.image = img;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.alpha <= 0.01) {
        return nil;
    }
    
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    __block UIView *v = nil;
    [self.superview.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint vpoint = [self convertPoint:point toView:obj];
        if ([obj hitTest:vpoint withEvent:event]) {
            v = obj;
            *stop = YES;
        }
    }];
    return v;
}

@end
