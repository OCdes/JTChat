//
//  RequestManager.m
//  Swift-jtyh
//
//  Created by LJ on 2020/6/2.
//  Copyright © 2020 WanCai. All rights reserved.
//

#import "RequestManager.h"
#import "PCHeader.h"
@implementation RequestManager

+ (void)postWithApi:(NSString *)api params:(NSDictionary *)params success:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull, NSDictionary * _Nonnull))success failure:(void (^)(NSNumber * _Nonnull, NSString * _Nonnull))failure {
    NSMutableArray *marr = [NSMutableArray array];
    if (params.allKeys.count > 0 && params) {
        for (int i = 0; i < params.allKeys.count; i ++) {
            NSString *key = params.allKeys[i];
            NSString *value = params.allValues[i];
            [marr addObject:NSStringFormate(@"%@=%@",key, value)];
        }
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:NSStringFormate(@"%@/%@",agentUrl,api)];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:jwt forHTTPHeaderField:@"jwt"];
    NSLog(@"url:%@ jwt:%@",api,request.allHTTPHeaderFields);
    if (marr.count) {
        request.HTTPBody = [[marr componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *err = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (!err) {
                NSLog(@"%@", result);
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)result;
                    NSNumber *code = dict[@"code"];
                    NSString *msg = dict[@"msg"];
                    if ([code isEqualToNumber:@(0)]) {
                        success(code, msg, dict);
                    } else if ([code isEqualToNumber:@(501)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SHOW_ERROE(msg)
                            [RootConfig reLogin];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SHOW_ERROE(msg)
                        });
                        failure(code, msg);
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SHOW_ERROE(@"服务未知错误，请联系管理员")
                    });
                    failure(@(-400), @"服务未知错误，请联系管理员");
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_ERROE(err.description)
                });
                failure(@(err.code), err.description);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SHOW_ERROE(@"服务未知错误，请联系管理员")
            });
            failure(@(-400), @"服务未知错误，请联系管理员");
        }
    }];
    [task resume];
}

@end
