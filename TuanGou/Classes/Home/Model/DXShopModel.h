//
//  DXShopModel.h
//  TuanGou
//
//  Created by simon on 16/5/13.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXShopModel : NSObject
@property (nonatomic, strong) NSNumber *shop_id;//商户id
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *distance;//当前距离与商户之间的距离，没有传递longitude，latitude字段会                                           返回-1
@property (nonatomic, strong) NSString *shop_url;
@end
