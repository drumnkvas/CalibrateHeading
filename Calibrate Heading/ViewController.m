//
//  ViewController.m
//  Calibrate Heading
//
//  Created by Vasily Sverchkov on 27.12.16.
//  Copyright © 2016 Vasily Sverchkov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UILabel *headingLabel;
@property (strong, nonatomic) UILabel *headingMagnetLabel;
@property (strong, nonatomic) UILabel *headingAccuracyLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1000;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse)
        [_locationManager requestWhenInUseAuthorization];

    [_locationManager startUpdatingLocation];

    if ([CLLocationManager headingAvailable]) {
        _locationManager.headingFilter = 5;
        [_locationManager startUpdatingHeading];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
    _headingMagnetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 300, 100)];
    _headingAccuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 300, 100)];

    [_headingLabel setText:@"Heading 0"];
    [_headingMagnetLabel setText:@"Magnet 0"];
    [_headingAccuracyLabel setText:@"Accuracy 0"];

    [self.view addSubview:_headingLabel];
    [self.view addSubview:_headingMagnetLabel];
    [self.view addSubview:_headingAccuracyLabel];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) {
        NSLog(@"Heading accuracy is %f", newHeading.headingAccuracy);
        return;
    }

    [_headingLabel setText:[NSString stringWithFormat:@"Heading %f", newHeading.trueHeading]];
    [_headingMagnetLabel setText:[NSString stringWithFormat:@"Magnet %f", newHeading.magneticHeading]];
    [_headingAccuracyLabel setText:[NSString stringWithFormat:@"Accuracy %f", newHeading.headingAccuracy]];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User is still thinking");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location services");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [_locationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"update!");
}

-(BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    NSLog(@"HAVE TO CALIBRATE");
    return YES;
}

@end
