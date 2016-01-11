//
//  CYMapViewController.m
//  驾考刷题
//
//  Created by 程俊亚 on 15/12/27.
//  Copyright © 2015年 john. All rights reserved.
//

#import "CYMapViewController.h"
#import <MapKit/MapKit.h>
@interface CYMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnClick;
- (IBAction)searchBtn:(id)sender;

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *city;

@end

@implementation CYMapViewController

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.rightBarButtonItem = item;

    //设置地图追踪用户的位置
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

}

#pragma mark - MKMapViewDelegate
/**
 * 当用户的位置更新了就会调用一次
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];

    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果没有数据,或者有错误
        if (placemarks.count == 0 || error != nil) return;

        // 取出CLPlaceMark
        CLPlacemark *placemark = [placemarks firstObject];

        if (placemark.locality == nil) { // 当城市是自治区的时候,需要使用administrativeArea
            userLocation.title = placemark.administrativeArea;
        } else { // 不是自治区,使用locality
            userLocation.title = placemark.locality;
        }
        userLocation.subtitle = placemark.name;
    }];
}


- (IBAction)searchBtn:(id)sender {
    //设置地图追踪用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
@end
