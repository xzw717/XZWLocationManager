//
//  HQJLocationManager.h
//  HQJBusiness
//
//  Created by Ethan on 2020/8/21.
//  Copyright © 2020 Fujian first time iot technology investment co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^HQJLocationBlock)(CGFloat lat,CGFloat lon,NSString * _Nonnull cityName);
NS_ASSUME_NONNULL_BEGIN

@interface HQJLocationManager : NSObject<NSCopying, NSMutableCopying>
@property (nonatomic, copy  ) HQJLocationBlock location;
/// 获取实例对象
+ (instancetype)shareInstance ;
/// 获取定位权限并开始定位
- (instancetype)getLocation;
/// 停止定位
- (void)stopLocation;
@end

NS_ASSUME_NONNULL_END
