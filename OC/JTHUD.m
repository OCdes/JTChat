//
//  JTHUD.m
//  JingTeYuHui
//
//  Created by LJ on 2019/5/16.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "JTHUD.h"
#import "PCHeader.h"
@implementation JTHUD

+ (void)showErrorWithStatus:(NSString *)status {
    [super showImage:[UIImage imageNamed:@"attention"] status:status];
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setBackgroundColor:HEX_333];
//    [self setMinimumSize:CGSizeMake(269, 131)];
//    [self setFont:SYS_FONT(26)];
    [self setForegroundColor:HEX_FFF];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    DISMISS_HUD(3);
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [super showSuccessWithStatus:status];
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setBackgroundColor:HEX_333];
//    [self setMinimumSize:CGSizeMake(269, 131)];
//    [self setFont:SYS_FONT(26)];
    [self setForegroundColor:HEX_FFF];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    DISMISS_HUD(3);
}

+ (void)showWithStatus:(NSString *)status {
    [super showWithStatus:status];
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setBackgroundColor:HEX_333];
//    [self setMinimumSize:CGSizeMake(269, 131)];
//    [self setFont:SYS_FONT(26)];
    
    [self setForegroundColor:HEX_FFF];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    DISMISS_HUD(10);
}

+ (void)showProgress:(float)progress status:(NSString *)status {
    [super showProgress:progress status:status];
    [self setDefaultStyle:SVProgressHUDStyleDark];
    [self setBackgroundColor:HEX_333];
//    [self setMinimumSize:CGSizeMake(269, 131)];
//    [self setFont:SYS_FONT(26)];
    [self setForegroundColor:HEX_FFF];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    DISMISS_HUD(3);
}


- (UIColor*)foregroundColorForStyle {
    if(self.defaultStyle == SVProgressHUDStyleLight) {
        return [UIColor blackColor];
    } else if(self.defaultStyle == SVProgressHUDStyleDark) {
        return [UIColor whiteColor];
    } else {
        return self.foregroundColor;
    }
}

@end
