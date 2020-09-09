//
//  ViewController.m
//  XZWLocationManage
//
//  Created by Ethan on 2020/9/8.
//  Copyright © 2020 Fujian first time iot technology investment co., LTD. All rights reserved.
//

#import "ViewController.h"
#import "HQJLocationManager.h"
@interface ViewController ()
@property (nonatomic, strong) UILabel *label;;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 500, 30)];
    self.label.textColor = [UIColor blackColor];
    self.label.text = @"暂无位置信息";
    [self.view addSubview:self.label];
    
 



}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[HQJLocationManager shareInstance]getlocations];
//    [[HQJLocationManager shareInstance]setLocation:^(CGFloat lat, CGFloat lon, NSString * _Nonnull cityName) {
//        NSLog(@"%f,%f,%@",lat,lon,cityName);
//        self->label.text = [NSString stringWithFormat:@"经度：%f 纬度：%f 城市：%@",lon,lat,cityName];
//    }];
    
    [[[HQJLocationManager shareInstance] getLocationWithLocationStyle:Wgs84ToGcj02LocationStyle] setLocation:^(CGFloat lat, CGFloat lon, NSString * _Nonnull cityName) {
        self.label.text = [NSString stringWithFormat:@"经度：%f 纬度：%f 城市：%@",lon,lat,cityName];
     }];
}

@end
