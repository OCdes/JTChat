//
//  GeneralPickerView.m
//  JingTeYuHui
//
//  Created by LJ on 2019/7/24.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralPickerView.h"
#import "PCHeader.h"
@implementation GeneralPickerView
{
    UIView *_selectBackView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.subviews.count) {
        [self updateSelectView];
    }
}

- (void)updateSelectView {
    //修改线条颜色
    UIView *line1 = self.subviews[1];
    line1.backgroundColor = [UIColor clearColor];
    UIView *line2 = self.subviews[2];
    line2.backgroundColor = [UIColor clearColor];
    
    //修改选中行的背景色
    for (UIView *subView in self.subviews) {
        if(subView.subviews.count){
            UIView *contentView = subView.subviews[0];
            for (UIView *contentSubView in contentView.subviews) {
                if(contentSubView.center.y == contentView.center.y){
                    if(_selectBackView != contentSubView){
                        _selectBackView.backgroundColor = [UIColor clearColor];
                        _selectBackView = contentSubView;
                        _selectBackView.backgroundColor = UIColor.whiteColor;
                    }
                    break;
                }
            }
            break;
        }
    }
}

@end
