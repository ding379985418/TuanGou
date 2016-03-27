//
//  DXNetRequest.m
//  ApiStoreSDKDemo
//
//  Created by No on 16/3/25.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import "DXNetRequest.h"
#import "ApiStoreSDK.h"
@interface DXNetRequest ()


@end
@implementation DXNetRequest
//基本网络请求方法
+ (void)request:(ReuestMethod)method
         urlStr:(NSString *)urlStr
         params:(NSDictionary *)params
       complete:(void(^)())completeBlock
         sucess:(void(^)(long status ,id result))sucessBlock
        failure:(void(^)(long status , NSString *errorStr))failureBlock

{
    //请求API
    [ApiStoreSDK executeWithURL:urlStr
                         method:[self getMethod:method]
                         apikey:DXAPIKey
                      parameter:[[NSMutableDictionary alloc] initWithDictionary:params]
                       callBack:[self getCallBackWithComplete:completeBlock sucess:sucessBlock failure:failureBlock]];

}
//获取回调
+ (APISCallBack *)getCallBackWithComplete:(void(^)())completeBlock
                                   sucess:(void(^)(long status ,id result))sucessBlock
                                  failure:(void(^)(long status , NSString *errorStr))failureBlock{
    APISCallBack* callBack = [APISCallBack alloc];
    
    callBack.onSuccess = ^(long status, NSString *responseString) {
        NSLog(@"onSuccess");
        if(responseString != nil) {
//             NSLog(@"%@",responseString);
            id result = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (sucessBlock) {
                sucessBlock(status,result);
            }
        }
        
    };
    
    callBack.onError = ^(long status,  NSString *responseString) {
        NSLog(@"onError");
        if (failureBlock) {
            failureBlock(status,responseString);
        }
        
    };
    
    callBack.onComplete = ^() {
        if (completeBlock) {
            completeBlock();
        }
    };


    return callBack;
}
//获取方法
+ (NSString *)getMethod:(ReuestMethod)method{
    NSString *methodStr;
    
    switch (method) {
        case GET:
            methodStr = @"get";
            break;
        case POST:
            methodStr = @"post";
            break;
        case PUT:
            methodStr = @"put";
            break;
        case DELETE:
            methodStr = @"delete";
            break;
        default:
            methodStr = @"get";
            break;
    }

    return methodStr;
}
@end
