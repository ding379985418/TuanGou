//
//  DXNetRequest.h
//  ApiStoreSDKDemo
//
//  Created by No on 16/3/25.
//  Copyright © 2016年 KessonWu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    POST,    //POST方法
    GET,     //GET方法
    PUT,     //PUT方法
    DELETE   //DELETE方法
} ReuestMethod;
@interface DXNetRequest : NSObject

///基本网络请求方法
+ (void)request:(ReuestMethod)method
         urlStr:(NSString *)urlStr
         params:(NSDictionary *)params
       complete:(void(^)())completeBlock
         sucess:(void(^)(long status ,id result))sucessBlock
        failure:(void(^)(long status , NSString *errorStr))failureBlock;
@end
