//
//  DXDropNotificationModel.h
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDropNotificationModel : NSObject
//主标题
@property (nonatomic, copy) NSString *titleStr;
//主类id
@property (nonatomic, strong) NSNumber *mas_id;
//副标题
@property (nonatomic, copy) NSString *subTitleStr;
//子类id
@property (nonatomic, strong) NSNumber *sub_id;
@end
