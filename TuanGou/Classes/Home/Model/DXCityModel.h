//
//  DXCityModel.h
//  TuanGou
//
//  Created by simon on 16/3/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXCityModel : NSObject
@property (nonatomic, strong) NSNumber *city_id;//城市id
@property (nonatomic, copy) NSString *city_name;//城市名称
@property (nonatomic, copy) NSString *short_name;//城市名称简写
@property (nonatomic, copy) NSString *city_pinyin;//城市名称拼音
@property (nonatomic, copy) NSString *short_pinyin;//城市名称拼音简写
@end
