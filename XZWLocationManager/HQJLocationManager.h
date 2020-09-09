//
//  HQJLocationManager.h
//  HQJBusiness
//
//  Created by Ethan on 2020/8/21.
//   此类为单例类
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^HQJLocationBlock)(CGFloat lat,CGFloat lon,NSString * _Nonnull cityName);
NS_ASSUME_NONNULL_BEGIN

// WGS-84世界标准坐标、GCJ-02中国国测局(火星坐标,高德坐标,腾讯地图坐标)、BD-09百度坐标系转换
typedef NS_ENUM (NSInteger,LocationStyle) {
    /// 默认的 ，返回 WGS-84
    DefaultLocationStyle = 0,
    /// 返回 GCJ-02 坐标
    Wgs84ToGcj02LocationStyle,
    /// 返回 BD-09 坐标
    Wgs84ToBd09LocationStyle

};
@interface HQJLocationManager : NSObject<NSCopying, NSMutableCopying>
@property (nonatomic, copy  ) HQJLocationBlock location;
/// 获取实例对象
+ (instancetype)shareInstance ;

/// 获取定位权限并开始定位  此方法返回实例对象方便直接调用定位 Block
- (instancetype)getLocationWithLocationStyle:(LocationStyle)style;
/// 默认是程序在前台会持续定位，单次定位需调用这个方法
- (instancetype)singleLocation;
/// 手动停止定位
- (void)stopLocation;
- (void)getlocations ;
@end

NS_ASSUME_NONNULL_END
