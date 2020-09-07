//
//  HQJLocationManager.m
//  HQJBusiness
//
//  Created by Ethan on 2020/8/21.
//  Copyright © 2020 Fujian first time iot technology investment co., LTD. All rights reserved.
//

#import "HQJLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293

#define jzA 6378245.0
#define jzEE 0.00669342162296594323


@interface HQJLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationmanager;//定位服务
@property (nonatomic, strong) NSString *currentCity;//当前城市
@property (nonatomic, strong) NSString *strlatitude;//经度
@property (nonatomic, strong) NSString *strlongitude;//纬度
@end
@implementation HQJLocationManager
+ (instancetype)shareInstance {
    static HQJLocationManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)getLocation
{ //判断定位功能是否打开
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationmanager = [[CLLocationManager alloc]init];
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
           if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
               //由于IOS8中定位的授权机制改变 需要进行手动授权
               //获取授权认证
               [self.locationmanager requestWhenInUseAuthorization];
           }
        self.locationmanager.delegate = self;
        [self.locationmanager requestAlwaysAuthorization];
        self.currentCity = [NSString new];
//        [self.locationmanager requestWhenInUseAuthorization];
        //设置寻址精度
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationmanager.distanceFilter = 5.0;
        [self.locationmanager startUpdatingLocation];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{ //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[self currentViewControll] presentViewController:alert animated:YES completion:nil];
}

- (void)stopLocation {
    [self.locationmanager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationmanager stopUpdatingHeading]; //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init]; //打印当前的经度与纬度
//    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude); //反地理编码
    __weak typeof(self) weakSelf = self;
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            weakSelf.currentCity = placeMark.locality; if (!weakSelf.currentCity) {
                weakSelf.currentCity = @"无法定位当前城市";
            }
            CLLocationCoordinate2D locationNow = [HQJLocationManager wgs84ToGcj02:currentLocation.coordinate];
            !weakSelf.location ? :weakSelf.location(locationNow.latitude,locationNow.longitude,weakSelf.currentCity);

//            if (currentLocation.coordinate.latitude && currentLocation.coordinate.longitude && ![self.currentCity isEqualToString:@"无法定位当前城市"]) {
//                [self.locationmanager stopUpdatingLocation];
//            }
            //            NSLog(@"%@",self.currentCity);//当前的城市 // NSLog(@"%@",placeMark.subLocality);//当前的位置 // NSLog(@"%@",placeMark.thoroughfare);//当前街道 // NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
    
}

+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location
{
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
+ (BOOL)outOfChina:(double)lat bdLon:(double)lon
{
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}
+ (double)transformLat:(double)x bdLon:(double)y
{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}
+ (double)transformLon:(double)x bdLon:(double)y
{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}
- (UIViewController *)currentViewControll{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}
@end
